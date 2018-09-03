# frozen_string_literal: true

class CloseAccountJob < ApplicationJob
  queue_as :mailer

  def perform(email, name)
    return unless email

    ResidentNotificationMailer.close_account(email, name).deliver_now
  end
end
