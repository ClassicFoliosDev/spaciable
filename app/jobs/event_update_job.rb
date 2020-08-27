# frozen_string_literal: true

class EventUpdateJob < ApplicationJob
  queue_as :mailer

  def perform(event, resource_ids)
    EventNotificationMailer.update_resources(event, resource_ids).deliver_now
  end
end
