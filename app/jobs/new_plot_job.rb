# frozen_string_literal: true

class NewPlotJob < ApplicationJob
  queue_as :mailer

  def perform(plot_residency, subject, invited_by_name)
    return unless plot_residency

    ResidentNotificationMailer.new_plot(plot_residency, subject, invited_by_name).deliver_now
  end
end
