# frozen_string_literal: true

class SendResidentNotificationsJob < ApplicationJob
  queue_as :mailer

  def perform(resident_ids, notification, sender)
    return unless notification

    plot_ids = if notification.send_to_type == "Plot"
                 [notification.send_to_id]
               else
                 notification.send_to.plots.pluck(:id)
               end

    notify(resident_ids, notification, plot_ids, sender)
  end

  def notify(resident_ids, notification, plot_ids, sender)
    Resident.where(id: resident_ids).each do |resident|
      # If the sender is a CF admin, send the notification to all residents including expired
      sender_type = User.find_by(id: notification.sender_id)
      unless sender_type.cf_admin?
        resident_active_plots = gather_resident_plots(plot_ids)
        # The resident notification will not be created if all of the residents plots are expired
        next unless resident_active_plots.any?
      end

      next if resident.notifications.include?(notification)

      plot_residency = PlotResidency.find_by(resident_id: resident.id, plot_id: plot_ids)
      next unless plot_residency

      # Resident notification mailer will only mail if the resident has subscribed to email updates
      ResidentNotificationMailer.notify(plot_residency, notification, sender).deliver_now
      resident.notifications << notification
    end
  end

  def gather_resident_plots(plot_ids)
    # Find which of the residents plots is in the notification list
    resident_plots = Plot.where(id: plot_ids)

    # Check whether the resident has any active plots in the notification list
    resident_active_plots = []
    resident_plots.each do |plot|
      resident_active_plots << plot unless plot.expired?
    end
    resident_active_plots
  end
end
