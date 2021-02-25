# frozen_string_literal: true

class VisitsJob < ApplicationJob
  queue_as :admin

  def perform(user, visits_params)
    csv_file = Csv::VisitsCsvService.call(visits_params)
    TransferCsvJob.perform_later(user.email, user.first_name, csv_file.to_s)
  end
end
