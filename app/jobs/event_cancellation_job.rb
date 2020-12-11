# frozen_string_literal: true

class EventCancellationJob < ApplicationJob
  queue_as :mailer

  def perform(event, resource)
    EventNotificationMailer.cancel(event, resource).deliver_now
  end
end
