# frozen_string_literal: true

class NewPlotJob < ApplicationJob
  queue_as :mailer

  def perform(plot_residency, subject, invited_by)
    return unless plot_residency

    ResidentNotificationMailer.new_plot(plot_residency, subject, invited_by).deliver_now
  end
end
