# frozen_string_literal: true

class EventInvitationJob < ApplicationJob
  queue_as :mailer

  def perform(event, resource_ids)
    EventNotificationMailer.invite_resources(event, resource_ids).deliver_now
  end
end
