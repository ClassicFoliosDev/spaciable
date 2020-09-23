# frozen_string_literal: true

class EventCancellationJob < ApplicationJob
  queue_as :mailer

  def perform(event, resource_ids)
    EventNotificationMailer.cancel(event, resource_ids).deliver_now
  end
end
