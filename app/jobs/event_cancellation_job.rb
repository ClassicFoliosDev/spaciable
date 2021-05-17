# frozen_string_literal: true

class EventCancellationJob < ApplicationJob
  queue_as :mailer

  def perform(event, resource)
    EventNotificationMailer.cancel_resources(event, resource)
  end
end
