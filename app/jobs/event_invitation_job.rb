# frozen_string_literal: true

class EventInvitationJob < ApplicationJob
  queue_as :mailer

  def perform(event, resource)
    EventNotificationMailer.invite_resource(event, resource).deliver_now
  end
end
