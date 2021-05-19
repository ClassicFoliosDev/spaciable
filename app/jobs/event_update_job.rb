# frozen_string_literal: true

class EventUpdateJob < ApplicationJob
  queue_as :mailer

  def perform(event, resource)
    EventNotificationMailer.update_resources(event, resource)
  end
end
