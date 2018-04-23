# frozen_string_literal: true

class InvitationReminderJob < ApplicationJob
  queue_as :mailer

  def perform(plot_residency, subject, token, invited_by = nil)
    return unless plot_residency
    invited_by = plot_residency.plot.developer if invited_by.nil?

    ResidentNotificationMailer.remind(plot_residency, subject, token, invited_by).deliver_now
  end
end
