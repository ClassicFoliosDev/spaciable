# frozen_string_literal: true

class AutoCompletePlotsJob < ApplicationJob
  queue_as :mailer

  # rubocop:disable Metrics/LineLength, Rails/SkipsModelValidations
  def perform
    # only run on the last day of the month
    return unless Date.today.month != Date.tomorrow.month

    Lock.run :auto_complete_plots do
      plots = Plot.joins(:developer)
                  .where(completion_release_date: nil)
                  .where("plots.reservation_release_date < NOW() - interval '1 month' * developers.auto_complete")
                  .order(:developer_id, :development_id, :phase_id, :number)

      # auto complete
      plots.update_all(auto_completed: Time.zone.now)
      csv_file = build_csv(plots)

      TransferCsvJob.perform_later("support@classicfolios.com", "Support", csv_file.to_s)
      TransferCsvJob.perform_later("katherine@classicfolios.com", "Kat", csv_file.to_s)
    end
  end
  # rubocop:enable Metrics/LineLength, Rails/SkipsModelValidations

  def build_csv(plots)
    Csv::AutoCompleteCsvService.call(plots)
  end
end
