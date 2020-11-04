# frozen_string_literal: true

class ResidentInvitationSummaryJob < ApplicationJob
  queue_as :mailer

  def perform
    users = User.where(receive_invitation_emails: true).where.not(permission_level_id: nil)
    users.each { |user| build_report(user) }
  end

  def build_report(user)
    plots = user.permission_level&.plots
    return unless plots

    residencies = PlotResidency.where(plot_id: plots,
                                      created_at: ((Time.zone.now - 7.days)..Time.zone.now))

    return unless residencies.size.positive?
    InvitationSummaryMailer.resident_summary(user, residencies.to_a).deliver_later
  end
end
