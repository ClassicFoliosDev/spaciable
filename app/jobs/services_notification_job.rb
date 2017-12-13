# frozen_string_literal: true

class ServicesNotificationJob < ApplicationJob
  queue_as :mailer

  def perform(resident, old_service_names, plots)
    ApplicationMailer.request_services(resident, old_service_names, plots).deliver_now
  end
end
