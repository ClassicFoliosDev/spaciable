# frozen_string_literal: true

class EventUpdateJob < ApplicationJob
  queue_as :mailer

  def perform(event, resource)
    EventNotificationMailer.update_resource(event, resource).deliver_now
  end
end
