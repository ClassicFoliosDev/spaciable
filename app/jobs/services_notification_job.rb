# frozen_string_literal: true

class ServicesNotificationJob < ApplicationJob
  queue_as :mailer

  def perform(resident, old_service_names)
    # TODO: temporary assumption of first plot
    plot = resident.plots.first
    ApplicationMailer.request_services(resident, old_service_names, plot).deliver_now
  end
end
