# frozen_string_literal: true

class EventReminderJob < ApplicationJob
  queue_as :mailer

  def perform(event)
    EventNotificationMailer.remind_sender(event).deliver_now
    EventNotificationMailer.remind_resources(event).deliver_now
  end
end
