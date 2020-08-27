# frozen_string_literal: true

class EventFeedbackJob < ApplicationJob
  queue_as :mailer

  def perform(resource)
    EventNotificationMailer.feedback(resource).deliver_now
  end
end
