# frozen_string_literal: true

class TransferCsvJob < ApplicationJob
  queue_as :mailer

  def perform(email, name, filename)
    return unless email

    AdminNotificationMailer.csv_report_download(email, name, filename).deliver_now
  end
end
