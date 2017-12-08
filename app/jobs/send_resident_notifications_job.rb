# frozen_string_literal: true

class SendResidentNotificationsJob < ApplicationJob
  queue_as :mailer

  def perform(resident_ids, notification)
    return unless notification

    plot_ids = if notification.send_to_type == "Plot"
                 [notification.send_to_id]
               else
                 notification.send_to.plots.pluck(:id)
               end

    Resident.where(id: resident_ids).each do |resident|
      resident.notifications << notification
      plot_residency = PlotResidency.find_by(resident_id: resident.id, plot_id: plot_ids)
      ResidentNotificationMailer.notify(plot_residency, notification).deliver_now
    end
  end
end
