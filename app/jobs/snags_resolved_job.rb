# frozen_string_literal: true

class SnagsResolvedJob < ApplicationJob
  queue_as :mailer

  def perform(*args)
    notification = Notification.find_by(id: args.first)
    plot = Plot.where(id: notification.send_to_id).first

    ResidentSnagService.delayed_resolved(plot, notification) unless notification.nil?
  end
end
