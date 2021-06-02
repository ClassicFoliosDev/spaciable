# frozen_string_literal: true

class EventNotificationMailer < ApplicationMailer
  default from: "hello@spaciable.com", content_type: "multipart/alternative"

  def remind_sender(event)
    @event = event
    @parent = @event.eventable
    @link = admin_link(@event)
    @name = User.find_by(email: event.email)&.first_name
    mail to: event.email,
         subject: "Calendar event at #{@parent&.development_name} " \
                  "is happening #{ReminderEnum.reminder(@event.reminder)}"
  end

  def self.remind_resources(event, resource)
    return unless resource&.resourceable&.emails&.present?
    return if resource.declined?

    resource.resourceable.emails.each do |email|
      remind_resource(event, resource, email).deliver_now
    end
  end

  def remind_resource(event, resource, email)
    init(event, resource, email)
    mail to: email,
         subject: "Calendar event at #{@plot&.development_name} " \
                  "is happening #{ReminderEnum.reminder(@event.reminder)}"
  end

  def self.invite_resources(event, resource)
    return unless resource&.resourceable&.emails&.present?

    resource.resourceable.emails.each do |email|
      invite_resource(event, resource, email).deliver_now
    end
  end

  def invite_resource(event, resource, email)
    init(event, resource, email)
    mail to: email,
         subject: "New calendar Event at #{@plot&.development_name}"
  end

  def self.update_resources(event, resource)
    return unless resource&.resourceable&.emails&.present?

    resource.resourceable.emails.each do |email|
      update_resource(event, resource, email).deliver_now
    end
  end

  def update_resource(event, resource, email)
    init(event, resource, email)
    mail to: email,
         subject: "Calendar event updated at #{@plot&.development_name}"
  end

  def self.cancel_resources(event, resource)
    return unless resource&.resourceable&.emails&.present?

    resource.resourceable.emails.each do |email|
      cancel(event, resource, email).deliver_now
    end
  end

  def cancel(event, resource, email)
    init(event, resource, email)
    mail to: email,
         subject: "Calendar event cancellation: #{@event&.title}"
  end

  def feedback(resource)
    @resource = resource
    @event = @resource.event
    @plot = if @event.eventable.is_a? Plot
              @event.eventable
            else
              @resource.resourceable
            end
    @link = admin_link(resource.event)
    @name = resource.event.userable.first_name
    mail to: resource.event.userable.email,
         subject: "Calendar event #{resource.status} by #{resource.resourceable}"
  end

  def resource_link(event)
    homeowner_calendar_url(event: event.id)
  end

  def admin_link(event)
    case event.eventable_type
    when "Plot"
      plot_url(event.eventable_id,
               active_tab: "calendar",
               event: event.id)
    when "Development"
      development_calendars_url(event.eventable_id,
                                event: event.id)
    when "Phase"
      phase_calendars_url(event.eventable_id,
                          event: event.id)
    end
  end

  def init(event, resource, email)
    eventable = event.eventable # otherwise rails_best_practices errors :(
    @plot = if eventable.is_a?(Plot)
              event.eventable
            elsif resource.resourceable.is_a?(Plot)
              resource.resourceable
            end
    @event = event
    @link = resource_link(event)
    @name = Resident.find_by(email: email)&.first_name
  end
end
