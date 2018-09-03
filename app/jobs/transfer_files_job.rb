# frozen_string_literal: true

class TransferFilesJob < ApplicationJob
  queue_as :mailer

  def perform(email, name, url, plot_name)
    return unless email

    ResidentNotificationMailer.transfer_files(email, name, url, plot_name).deliver_now
  end
end
