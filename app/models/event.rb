# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength, SkipsModelValidations
class Event < ApplicationRecord
  include RepeatEnum
  include ReminderEnum
  belongs_to :eventable, polymorphic: true
  belongs_to :userable, polymorphic: true
  has_one :master, class_name: "Event"
  has_many :event_resources, inverse_of: :event, dependent: :delete_all
  accepts_nested_attributes_for :event_resources, allow_destroy: true

  before_destroy :note, prepend: true
  before_destroy :cleanup
  before_update :note
  after_save :notify_reminder, :reset_reproposed

  delegate :email, to: :userable
  delegate :id, to: :eventable, prefix: true
  delegate :time_zone, to: :eventable
  delegate :full_name, to: :userable

  # include event_resources in duplications
  amoeba do
    include_association :event_resources
  end

  # Get events of eventable_type 'e_type' with ids in 'e_ids'
  # and date/times between 'start' and 'end'
  scope :within_range,
        lambda { |e_type, e_ids, start, finish|
          where(eventable_type: e_type, eventable_id: e_ids)
            .where("events.start <= ? AND ? <= events.end",
                   Event.utc(finish), Event.utc(start))
        }

  # Get events of eventable_type 'e_type' with id 'e_id'
  # and associated resources of type 'r_type' with ids in 'r_ids'
  # and date/times between 'start' and 'end'
  # rubocop:disable Metrics/ParameterLists
  scope :resources_within_range,
        lambda { |e_type, e_id, r_type, r_ids, start, finish|
          joins(:event_resources)
            .where(eventable_type: e_type,
                   eventable_id: e_id,
                   event_resources: { resourceable_type: r_type,
                                      resourceable_id: r_ids })
            .where("events.start <= ? AND ? <= events.end",
                   Event.utc(finish), Event.utc(start))
        }
  # rubocop:enable Metrics/ParameterLists

  # Get the events of a specified type with associated resources
  # of a specified type within a range of ids.  This would be used
  # for residents that reside at multiple properties
  scope :for_resources_within_range,
        lambda { |e_type, r_type, r_ids, start, finish|
          joins(:event_resources)
            .where(eventable_type: e_type,
                   event_resources: { resourceable_type: r_type,
                                      resourceable_id: r_ids })
            .where("events.start <= ? AND ? <= events.end",
                   Event.utc(finish), Event.utc(start))
            .uniq
        }

  scope :events,
        lambda { |id|
          where(id: id).or(where(master_id: id)).order(:id)
        }

  enum repeat_edit: %i[
    this_event
    this_and_following
    all_events
  ]

  # parse a date into a UTC time.  The calendar requests events between dates but if there is
  # a time zone offset (ie BST) then the event UTC date may be in the prev day. i.e. midnight
  # on 25/8 (in BST) will be 24/8 23:00 and so would not be included in the date range.  So
  # we need to convert the supplied date to a UTC date/time
  def self.utc(dt)
    Time.strptime(dt, "%Y-%m-%d").in_time_zone("UTC")
  end

  # is this a master
  def master?
    !child?
  end

  # is this a child
  def child?
    master_id.present?
  end

  # Get the master ID
  def master
    master_id || id
  end

  def duration
    self.end - start
  end

  def children
    Event.where(master_id: id).order(:start)
  end

  def repeater?
    master_id.present? || Event.where(master_id: id).present?
  end

  # Get all the events associated with this event
  def repeating_events
    Event.events(master)
  end

  # Build an event.  This involves creating the event itself and
  # any associated event resources and saving them all together as
  # a single operation
  def self.build(event_params, event_resources, resource_type)
    # create the event
    event = Event.new(event_params)
    # and associated resources
    event_resources&.each do |resource_id|
      next if resource_id.empty?

      event.event_resources
           .build(resourceable_type: resource_type,
                  resourceable_id: resource_id.to_i,
                  status: EventResource.statuses[:invited])
    end
    event.save!
    event.process_repeats

    event
  end

  # Update an event record, and associated resources
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, TimeZone
  def update(params, resources, resource_type, repeat_edit)
    params = params.except(:id, :master_id)
    dt_changed = dt_changed?(params)

    case repeat_edit.to_i
    when Event.repeat_edits[:this_event]
      event = self
    when Event.repeat_edits[:this_and_following]
      event = self
    when Event.repeat_edits[:all_events]
      # calculate any date/time differences that have been made, then
      # make the change to the master event and let it proliferate
      event = Event.find(master)
      params[:start] = event.start - (start - DateTime.parse(params[:start]))
      params[:end] = event.end - (self.end - DateTime.parse(params[:end]))
    end

    event.assign_attributes(params)

    # update resoures
    old_res, new_res = compare_resources(resources)
    event.update_resources(old_res, new_res, resource_type, dt_changed)
    event.save!

    # process repeats
    case repeat_edit.to_i
    when Event.repeat_edits[:this_event]
      event.process_repeats unless repeater?
    when Event.repeat_edits[:this_and_following]
      event.delete_following(master)
      event.update_repeat(repeating_events.reject { |e| e.id == event.id }&.last&.start,
                          ignore_last: true)
      event.update_column(:master_id, nil)
      event.process_repeats
    when Event.repeat_edits[:all_events]
      event.delete_following
      event.process_repeats
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Timezone

  # Remove an event.  Event removal is complicated by the
  # 'repeat' option.  When the event is a repeater the
  # user selects how the removal is proliferated.
  def remove(repeat_edit)
    case repeat_edit.to_i
    when Event.repeat_edits[:this_event]
      last = self == repeating_events.last
      inherit
      destroy
      update_repeat if last
    when Event.repeat_edits[:this_and_following]
      remove_this_and_following
    when Event.repeat_edits[:all_events]
      remove_from(Event.all)
    end
  end

  def remove_this_and_following
    remove_from(Event.where("start >= ?", start))
    update_repeat(repeating_events&.last&.start)
  end

  # Calculate the date/time to notify the event
  def notify_at
    return if nix?

    remind(reminder, start)
  end

  # Process the repeat option
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def process_repeats
    return if never?

    # The repeats may run over time zone changes. ie 9am on the
    # 23rd Oct could be 8am (UTC+1), so 8am in the database and
    # converted to 9am (local) for display.  However.. on the 24th
    # after the clocks go back an hour and we are at UTC+0, then
    # 9am is 9am in the database (UTC) and 9am (local) displayed
    # This has to be taken into account when calculating repeats
    zone = eventable.time_zone
    prev_offset = start.in_time_zone(zone).utc_offset

    interval = repeat_interval(repeat)
    e_start = start + interval
    this_offset = e_start.in_time_zone(zone).utc_offset
    e_start += (prev_offset - this_offset) # adjust
    prev_offset = this_offset

    # duplicate the master, update the dates and save to
    # create each repeating event
    while e_start <= repeat_until.localtime.end_of_day
      repeat_event = amoeba_dup
      repeat_event.start = e_start
      repeat_event.end = e_start + duration
      repeat_event.master_id = id
      repeat_event.save!
      e_start += interval
      this_offset = e_start.in_time_zone(zone).utc_offset
      e_start += (prev_offset - this_offset) # adjust
      prev_offset = this_offset
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def update_resources(old_res, new_res, resource_type, dt_changed)
    # Add new resourses
    (new_res - old_res).each do |res|
      event_resources.build(resourceable_type: resource_type,
                            resourceable_id: res,
                            status: EventResource.statuses[:invited])
    end

    event_resources.each do |r|
      # remove deleted resources
      r.mark_for_destruction if (old_res - new_res).include?(r.resourceable_id)

      next unless dt_changed

      # set exsiting users back to invited if the date/times have changed
      r.status = :invited if (old_res & new_res).include?(r.resourceable_id)
    end
  end

  def delete_following(m_id = id)
    # delete repeating events after
    Event.where("id > ? AND master_id = ?", id, m_id).destroy_all
  end

  # update preceding events 'repeat_until' date.  e.g. If an event was
  # repeating daily until 10/5 then all the events in the repeat have
  # a repeat until value of 10/5.  If a 'delete this and following'
  # request is received for the event on the 2/5 then all repeating
  # events preceeding 2/5 need their repeat until value updated to
  # 1/5.
  #
  # When a 'this and following' update is required, then (like Google)
  # the 'this and following' events splits one seqeunce into 2.  The start
  # (first event) of the new sequence must not have its repeat_until
  # updated.  Only the events in the previous sequence must be updated.
  def update_repeat(repeat_until = repeating_events&.last&.start, ignore_last: false)
    return unless repeat_until

    # update preceding events 'repeat_until' date
    repeating_events.each do |e|
      next if ignore_last && e == repeating_events.last

      e.update_column(:repeat_until, repeat_until)
    end
  end

  # Dates and times are a nightmare.  In order for event times to
  # be correct in emails and messages, then they need to be converted
  # into the correct time zone
  def time_in_zone(attrib)
    raise(StandardError.new, "unrecognised or invalid parameter") \
      unless respond_to?(attrib) && (send(attrib).is_a? Time)

    send(attrib).in_time_zone(eventable.time_zone)
  end

  def attributes
    super.merge(signature: eventable.signature)
  end

  private

  # Remove any master or repeating events from the supplied list
  # of events
  def remove_from(events)
    events.where(master_id: master).destroy_all
    events.find_by(id: master)&.destroy
  end

  # If this is a master with children, then let the first
  # child inherit the responsibility for the children.  Make
  # the first child the master and the remainders its siblings
  def inherit
    return unless master? && children.present?

    new_master = children.first.id
    children.first.update_column(:master_id, nil)
    children.each { |child| child.update_column(:master_id, new_master) }
  end

  # Compare the supplied resources with the current resources
  # of the event.
  def compare_resources(resource_ids)
    set1 = event_resources.pluck(:resourceable_id)
    set2 = (resource_ids - [""]).map(&:to_i)

    return set1, set2
  end

  # Remember the event detals before an update is made so as
  # dynamic invites and cancelations can be made.  This is complicated
  # by the fact that Event is using accepts_nested_attributes_for event_resources.
  # At this point the event will have new resource records waiting to be added
  # and these will be present in the event_resources but they will have ID nil
  # waiting to be assigned when the event is saved.  We need to note the
  # current resources before additions/deletions.  Calling .all returns
  # these and ignores the records waiting to be added.  The amoeba_dup
  # could duplicate the resources but it would assign all records with a
  # nil id and so is useless for comparisons
  def note
    @pre_resources = event_resources.all.to_a
    @pre_event = amoeba_dup
  end

  # Identify the changes in resources. Added/Removed/Remain. Resources
  # need to receive different messages depending on the context of
  # the event. i.e If an event is updated with one resource being added
  # another removed and one remaining, then the added resource needs an
  # invite, the removed one needs a cancellation, and the remainer needs
  # an update
  def resource_changes
    prev_resources = @pre_resources&.map(&:resourceable_id) || []
    current, prev = compare_resources(prev_resources)
    return (current - prev), (prev - current), (current & prev)
  end

  # Make the necessary notifications.
  # rubocop:disable Metrics/CyclomaticComplexity
  def notify_reminder
    if id_changed? || start_changed? || reminder_changed?
      # new record or start/reminder added.  Calculate/update event reminder
      update_column(:reminder_id, EventNotificationService.remind(self))
    end

    # notofications only sent out if the event is a master (ie is a single
    # event or the master for a set of repeating events) or the event has been
    # edited - signified by the id not having changed
    return unless master? || !id_changed?

    # identify new/removed/remaining resources
    added, deleted, remain = resource_changes

    EventNotificationService.invite(self, resources(added))
    EventNotificationService.cancel(@pre_event, pre_resources(deleted))

    return unless start_changed? || end_changed? || location_changed?

    EventNotificationService.update(self, resources(remain))
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  # send cancellations and remove any queued event notofications
  def cleanup
    reminder = Delayed::Job.find_by(id: reminder_id)
    reminder&.delete

    return unless master?

    EventNotificationService.cancel(@pre_event, @pre_resources)
  end

  # As long as none of the related resources have a a status of
  # reproposed then remove any propsed start/end dates from the event
  def reset_reproposed
    return if event_resources.find_by(status: :reproposed)

    # clear out the proposed dates if they are present
    return unless proposed_start.present? || proposed_end.present?

    update_columns(proposed_start: nil, proposed_end: nil)
  end

  def resources(resource_ids)
    event_resources.where(resourceable_id: resource_ids)
  end

  def pre_resources(resource_ids)
    @pre_resources&.select { |r| resource_ids.include? r.resourceable_id }
  end

  # have the date times changed?
  def dt_changed?(params)
    start != Time.parse(params[:start]) || self.end != Time.parse(params[:end])
  end
end
# rubocop:enable Metrics/ClassLength, SkipsModelValidations
