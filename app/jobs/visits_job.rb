# frozen_string_literal: true

class VisitsJob < ApplicationJob
  queue_as :admin

  def perform(user, visits_params)
    csv_file = Csv::VisitsCsvService.call(visits_params)

    # only process report with wetransfer if report returns any data
    transfer_url = Csv::CsvTransferService.call(csv_file, user) if csv_file.readlines.size > 1
    TransferCsvJob.perform_later(user.email, user.first_name, transfer_url)
  end
end
