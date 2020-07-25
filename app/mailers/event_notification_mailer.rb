# frozen_string_literal: true

class EventNotificationMailer < ApplicationMailer
  def remind_sender(event)
    @content = "Event alert"
    mail to: event.userable.email, subject: "Sender Event Alert"
  end

  def remind_resources(event)
    return if event.event_resources.empty?

    @content = "Event alert"
    mail to: event.event_resources.map { |r| r.resourceable.email },
         subject: "Homeowner Event Alert"
  end

  def invite_resources(event, resource_ids)
    return if resource_ids.empty?

    @content = "Event invite"

    mail to: resource_emails(event, resource_ids),
         subject: "Homeowner Event invite"
  end

  def update_resources(event, resource_ids)
    return if resource_ids.empty?

    @content = "Event update"
    mail to: resource_emails(event, resource_ids),
         subject: "Homeowner Event update"
  end

  def cancel(event, resource_ids)
    return if resource_ids.empty?

    @content = "Event cancelled"
    mail to: resource_emails(event, resource_ids),
         subject: "Homeowner Event cancellation"
  end

  def feedback(resource)
    @content = "Event #{resource.status} by #{resource.resourceable}"
    @link = plot_url(resource.event.eventable.id,
                     active_tab: "calendar",
                     event: resource.event.id)
    mail to: resource.event.userable.email,
         subject: "Event #{resource.status}"
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
end
