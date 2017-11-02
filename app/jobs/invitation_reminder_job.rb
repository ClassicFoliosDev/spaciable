# frozen_string_literal: true

class InvitationReminderJob < ApplicationJob
  queue_as :mailer

  def perform(resident, subject, token)
    ResidentNotificationMailer.remind(resident, subject, token).deliver_now
  end
end
