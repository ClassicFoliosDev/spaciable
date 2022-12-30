# frozen_string_literal: true

class ExpiryResidentsJob < ApplicationJob
  queue_as :mailer

  def perform(expiry_residents)
    return unless expiry_residents.count.positive?

    Resident.where(id: expiry_residents).each do |resident|
      ExpiryResidentMailer.notify_expiry_resident(resident).deliver_now
    end
  end
end
