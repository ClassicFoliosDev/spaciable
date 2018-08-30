# frozen_string_literal: true

class InvitationReminderJob < ApplicationJob
  queue_as :mailer

  def perform(plot_residency, subject, token, invited_by_name = nil)
    return unless plot_residency
    invited_by_name = plot_residency.plot.developer if invited_by_name.nil?

    ResidentNotificationMailer.remind(plot_residency, subject, token, invited_by_name).deliver_now
  end
end
