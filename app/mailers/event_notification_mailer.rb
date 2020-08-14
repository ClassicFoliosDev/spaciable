# frozen_string_literal: true

class EventNotificationMailer < ApplicationMailer
  default from: "hello@spaciable.com", content_type: "multipart/alternative"

  def remind_sender(event)
    @plot = event.eventable if event.eventable.is_a? Plot
    init_timezone(@plot)
    @event = event
    @link = admin_link(event)
    mail to: event.email,
         subject: "Calendar event at #{@plot&.development_name} " \
                  "is happening #{ReminderEnum.reminder(@event.reminder)}"
  end

  def remind_resources(event)
    return if event.event_resources.empty?

    init(event)
    mail to: event.event_resources.map { |r| r.resourceable.email },
         subject: "Calendar event at #{@plot&.development_name} " \
                  "is happening #{ReminderEnum.reminder(@event.reminder)}"
  end

  def invite_resources(event, resource_ids)
    return if resource_ids&.empty?

    init(event)
    mail to: resource_emails(event, resource_ids),
         subject: "New calendar Event at #{@plot&.development_name}"
  end

  def update_resources(event, resource_ids)
    return if resource_ids&.empty?

    init(event)
    mail to: resource_emails(event, resource_ids),
         subject: "Calendar event updated at #{@plot&.development_name}"
  end

  def cancel(event, resource_ids)
    return if resource_ids&.empty?

    init(event)
    mail to: resource_emails(event, resource_ids),
         subject: "Calendar event cancellation: #{@event&.title}"
  end

  def feedback(resource)
    @resource = resource
    @event = @resource.event
    @plot = @event.eventable if @event.eventable.is_a? Plot
    init_timezone(@plot)
    @link = admin_link(resource.event)
    mail to: resource.event.userable.email,
         subject: "Calendar event #{resource.status} by #{resource.resourceable}"
  end

  # Get the emails for the resources.  The event may
  # be a cancellation in which case it will
  # be a 'duplicate' (ie the event before the cancellation)
  # in which means the usual access methods don't work.
  # Extract emails by working through the resources
  def resource_emails(event, resource_ids)
    emails = []
    event.event_resources.each do |r|
      emails << r.resourceable.email if resource_ids.include?(r.resourceable_id)
    end
    emails
  end

  def resource_link(event)
    homeowner_calendar_url(event: event.id)
  end

  def admin_link(event)
    plot_url(event.eventable_id,
             active_tab: "calendar",
             event: event.id)
  end

  def init(event)
    @plot = event.eventable if event.eventable.is_a? Plot
    @event = event
    @link = resource_link(event)
    init_timezone(@plot)
  end

  def init_timezone(plot)
    # This sets the time zone for the current thread only
    Time.zone = plot.time_zone
  end
end
