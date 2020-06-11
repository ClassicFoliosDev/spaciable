# frozen_string_literal: true

class ResidentInvitationSummaryJob < ApplicationJob
  queue_as :mailer

  def perform(users)
    users.each { |user| build_report(user) }
  end

  def build_report(user)
    plots = user.permission_level&.plots
    return unless plots

    residencies = PlotResidency.where(plot_id: plots,
                                      created_at: ((Time.zone.now - 300.days)..Time.zone.now))

    InvitationSummaryMailer.resident_summary(user, residencies).deliver_later
  end
end
