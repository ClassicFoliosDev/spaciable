# frozen_string_literal: true

class CloseAccountJob < ApplicationJob
  queue_as :mailer

  def perform(email, name, url)
    return unless email

    ResidentNotificationMailer.close_account(email, name, url).deliver_now
  end
end
