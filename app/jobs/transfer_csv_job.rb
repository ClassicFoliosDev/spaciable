# frozen_string_literal: true

class TransferCsvJob < ApplicationJob
  queue_as :mailer

  def perform(email, name, file)
    return unless email

    AdminNotificationMailer.csv_report_download(email, name, file).deliver_now
  end
end
