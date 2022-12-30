# frozen_string_literal: true

class ExtendResidentJob < ApplicationJob
  queue_as :mailer

  def perform(resident)
    return unless resident

    ResidentNotificationMailer.access_extended(resident).deliver_now
  end
end
