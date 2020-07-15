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

  before_destroy :cleanup
  before_update :note
  after_save :notify

  # include event_resources in duplications
  amoeba do
    include_association :event_resources
  end

  scope :within_range,
        lambda { |params|
          where(eventable_type: params[:eventable_type],
                eventable_id: params[:eventable_id])
            .where("events.start <= ? AND ? <= events.end", params[:end], params[:start])
        }

  scope :for_resource_within_range,
        lambda { |resource, params|
          joins(:event_resources)
            .where(eventable_type: params[:eventable_type],
                   eventable_id: params[:eventable_id],
                   event_resources: { resourceable_type: resource.class.to_s,
                                      resourceable_id: resource.id })
            .where("events.start <= ? AND ? <= events.end", params[:end], params[:start])
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
    Event.events(master_id)
  end

  # Build an event.  This involves creating the event itself and
  # any associated event resources and saving them all together as
  # a single operation
  def self.build(event_params, event_resources = nil)
    # create the event
    event = Event.new(event_params)
    # and associated resources
    event_resources&.each do |resource_id|
      next if resource_id.empty?

      event.event_resources
           .build(resourceable_type: Resident,
                  resourceable_id: resource_id.to_i,
                  status: EventResource.statuses[:awaiting_acknowledgement])
    end
    event.save!
    event.process_repeats

    event
  end

  # Update an event record, and associated resources
  # rubocop:disable TimeZone
  def update(params, resources, repeat_edit)
    params.delete(:master_id)
    params.delete(:id)

    case Event.repeat_edits.key(repeat_edit.to_i)
    when "this_event"
      event = self
    when "this_and_following"
      event = self
    when "all_events"
      # calculate any date/time differences that have been made, then
      # make the change to the master event and let it proliferate
      event = Event.find(master)
      params[:start] = event.start - (start - DateTime.parse(params[:start]))
      params[:end] = event.end - (self.end - DateTime.parse(params[:end]))
    end

    event.assign_attributes(params)

    # update resoures
    old_res, new_res = compare_resources(resources)
    event.update_resources(old_res, new_res)
    event.save!

    case Event.repeat_edits.key(repeat_edit.to_i)
    when "this_event"
      event.process_repeats unless repeater?
    when "this_and_following"
      event.delete_following(master_id)
      event.update_repeat(repeating_events.reject { |e| e.id == event.id }.last.start)
      event.update_column(:master_id, nil)
      event.process_repeats
    when "all_event"
      event.delete_following
      event.process_repeats
    end
  end
  # rubocop:enable TimeZone

  def update_resources(old_res, new_res)
    # Add resourses
    (new_res - old_res).each do |res|
      event_resources.build(resourceable_type: "Resident", resourceable_id: res)
    end

    # remove deleted resources
    event_resources.each do |r|
      r.mark_for_destruction if (old_res - new_res).include?(r.resourceable_id)
    end
  end

  # Remove an event.  Event removal is complicated by the
  # 'repeat' option.  When the event is a repeater the
  # user selects how the removal is proliferated.
  def remove(repeat_edit)
    case Event.repeat_edits.key(repeat_edit.to_i)
    when "this_event"
      last = self == repeating_events.last
      inherit
      destroy
      update_repeat if last
    when "this_and_following"
      remove_this_and_following
    when "all_events"
      remove_from(Event.all)
    end
  end

  def remove_this_and_following
    remove_from(Event.where("start >= ?", start))
    update_repeat(repeating_events.last.start)
  end

  def update_repeat(repeat_until = repeating_events.last.start)
    return unless repeat_until

    # update preceding events 'repeat_until' date
    repeating_events.each do |e|
      e.update_column(:repeat_until, repeat_until)
    end
  end

  # destroy matching events from the supplied list
  def remove_from(events)
    events.where(master_id: master).destroy_all
    events.find_by(id: master)&.destroy
  end

  # If this is a master with children, then let the first
  # child inherit the responsibility for the children.  Make
  # the first child the master and the remainders children
  # of it
  def inherit
    return unless master? && children.present?

    new_master = children.first.id
    children.first.update_column(:master_id, nil)
    children.each { |child| child.update_column(:master_id, new_master) }
  end

  # Compare the supplied resources with the current resources
  # of the event.
  def compare_resources(resource_ids)
    set1 = event_resources.where(resourceable_type: "Resident")
                          .pluck(:resourceable_id)
    set2 = (resource_ids - [""]).map(&:to_i)

    return set1, set2
  end

  # Calculate the date/time to notify the event
  def notify_at
    return if nix?

    remind(reminder, start)
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
  # the event. i.e If an event is updated with one resident being added
  # another removed and one remaining, then the added resident needs an
  # invite, the removed one needs a cancellation, and the remainer needs
  # an update
  def resource_changes
    prev_resources = @pre_resources&.map(&:resourceable_id) || []
    current, prev = compare_resources(prev_resources)
    return (current - prev), (prev - current), (current & prev)
  end

  # Make the necessary notifications.
  def notify
    if id_changed? || start_changed? || reminder_changed?
      # new record or start/reminder added.  Calculate/update event reminder
      update_column(:reminder_id, EventNotificationService.remind(self))
    end

    return unless master?

    # identify new/removed/remaining residents
    added, deleted, remain = resource_changes

    EventNotificationService.invite(self, added)
    EventNotificationService.cancel(@pre_event, deleted)

    return unless start_changed? || end_changed? || location_changed?

    EventNotificationService.update(self, remain)
  end

  # Process the repeat option
  def process_repeats
    return if never?

    interval = repeat_interval(repeat)
    e_start = start + interval
    while e_start <= repeat_until.localtime.end_of_day
      repeat_event = amoeba_dup
      repeat_event.start = e_start
      repeat_event.end = e_start + duration
      repeat_event.master_id = id
      repeat_event.save!
      e_start += interval
    end
  end

  def delete_following(m_id = id)
    # delete repeating events after
    Event.where("id > ? AND master_id = ?", id, m_id).destroy_all
  end

  # send cancellations and remove any queued event notofications
  def cleanup
    reminder = Delayed::Job.find_by(id: reminder_id)
    reminder&.delete

    return unless master?

    EventNotificationService.cancel(self,
                                    event_resources&.map(&:resourceable_id))
  end
end
# rubocop:enable Metrics/ClassLength, SkipsModelValidations
