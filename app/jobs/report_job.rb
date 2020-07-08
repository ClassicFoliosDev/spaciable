# frozen_string_literal: true

class ReportJob < ApplicationJob
  queue_as :admin

  def perform(user, params:, report_params:)
    @report = Report.new(report_params.to_h)

    return unless @report.valid?
    csv_file = build_csv(params.to_h)
    # only process report with wetransfer if report returns any data
    transfer_url = Csv::CsvTransferService.call(csv_file, user) if csv_file.readlines.size > 1

    TransferCsvJob.perform_later(user.email, user.first_name, transfer_url)
  end

  def build_csv(params)
    return Csv::AllDeveloperCsvService.call(@report) if params["all"].present?
    return Csv::DeveloperCsvService.call(@report) if params["developer"].present?
    return Csv::BillingCsvService.call(@report) if params["billing"].present?
    return Csv::PerksCsvService.call(@report) if params["perks"].present?
    Csv::DevelopmentCsvService.call(@report)
  end
end
