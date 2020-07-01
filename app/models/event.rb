# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  belongs_to :userable, polymorphic: true
  has_many :event_resources, dependent: :delete_all

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
                event_resources: {resourceable_type: resource.class.to_s,
                                  resourceable_id: resource.id})
          .where("events.start <= ? AND ? <= events.end", params[:end], params[:start])
        }

  # build an event.  This involves creating the event itself and
  # any associated event resources
  def self.build(event_params, event_resources = nil)
    event = nil
    Event.transaction do
      # create the event
      event = Event.create(event_params)
      # and associated resources
      event_resources&.each do |resource_id|
        next if resource_id.empty?
        event.event_resources
             .build(resourceable_type: Resident,
                    resourceable_id: resource_id.to_i,
                    status: EventResource.statuses[:awaiting_acknowledgement])
      end
      event.save!
    end
    event
  end

  # Update an event record, and associated resources
  def update(params, resources = nil)
    Event.transaction do
      update_attributes(params)

      break unless resources.present?

      old_res = event_resources.where(resourceable_type: 'Resident')
                               .pluck(:resourceable_id)
      new_res = (resources - [""]).map(&:to_i)

      # Add the new resourses
      (new_res - old_res).each do |res|
        event_resources.build(
          resourceable_type: Resident,
          resourceable_id: res,
          status: EventResource.statuses[:awaiting_acknowledgement])
      end
      save! unless (new_res - old_res).empty?

      # remove those no longer required
      event_resources
        .where(resourceable_type: 'Resident',
               resourceable_id: (old_res - new_res)).destroy_all
    end
  end
end
