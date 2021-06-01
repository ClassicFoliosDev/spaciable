# frozen_string_literal: true

class EventReminderJob < ApplicationJob
  queue_as :mailer

  def perform(event)
    EventNotificationMailer.remind_sender(event).deliver_now
    event.event_resources.each do |resource|
      EventNotificationMailer.remind_resources(event, resource)
    end
  end
end
