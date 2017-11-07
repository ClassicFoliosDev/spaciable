# frozen_string_literal: true

class ServicesNotificationJob < ApplicationJob
  queue_as :mailer

  def perform(resident, old_service_names)
    ApplicationMailer.request_services(resident, old_service_names).deliver_now
  end
end
