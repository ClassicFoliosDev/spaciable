# frozen_string_literal: true

class InvitationReminderJob < ApplicationJob
  queue_as :mailer

  def perform(plot_residency, subject, token)
    return unless plot_residency

    ResidentNotificationMailer.remind(plot_residency, subject, token).deliver_now
  end
end
