# frozen_string_literal: true

class ExpiryPlotsJob < ApplicationJob
  queue_as :mailer

  def perform(expiry_plots, reduced_expiry_plots)
    # separate expiry and reduced expiry
    notify_expiry_plots(expiry_plots) if expiry_plots.count.positive?
    notify_reduced_expiry_plots(reduced_expiry_plots) if reduced_expiry_plots.count.positive?
  end

  def notify_expiry_plots(plot_ids)
    residencies = get_residencies(plot_ids)
    residencies.each do |residency|
      ExpiryPlotsMailer.notify_expiry_residents(residency).deliver_now
    end
  end

  def notify_reduced_expiry_plots(plot_ids)
    residencies = get_residencies(plot_ids)
    residencies.each do |residency|
      ExpiryPlotsMailer.notify_reduced_expiry_residents(residency).deliver_now
    end
  end

  def get_residencies(plot_ids)
    residencies = []
    # find each plot residency
    plot_ids.each do |plot_id|
      PlotResidency.where(plot_id: plot_id).each do |plot_residency|
        residencies << plot_residency
      end
    end
    residencies
  end
end
