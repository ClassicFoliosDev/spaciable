# frozen_string_literal: true

class CloseAccountJob < ApplicationJob
  queue_as :mailer

  def perform(resident, url)
    return unless resident

    ResidentNotificationMailer.close_account(resident, url).deliver_now
  end
end
