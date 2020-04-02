# frozen_string_literal: true

class DowngradePerksAccountJob < ApplicationJob
  queue_as :mailer

  def perform(name, email, id)
    ResidentNotificationMailer.downgrade_perks_account(name, email, id).deliver_later
  end
end
