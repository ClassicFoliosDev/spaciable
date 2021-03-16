# frozen_string_literal: true

class EventInvitationJob < ApplicationJob
  queue_as :mailer

  def perform(event, resource)
    EventNotificationMailer.invite_resources(event, resource)
  end
end
