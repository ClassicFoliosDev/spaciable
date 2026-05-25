# frozen_string_literal: true

class ReviveResidentJob < ApplicationJob
  queue_as :mailer

  def perform(residency)
    ReviveResidentMailer.revive_expired_resident(residency).deliver_now
  end
end
