# frozen_string_literal: true

class ReportJob < ApplicationJob
  queue_as :admin

  def perform(user, params:, report_params:)
    @report = Report.new(report_params.to_h)
    return unless @report.valid?
    csv_file = build_csv(params.to_h)

    TransferCsvJob.perform_later(user.email, user.first_name, csv_file.to_s)
  end

  def build_csv(params)
    return Csv::AllDeveloperCsvService.call(@report) if params["all"].present?
    return Csv::DeveloperCsvService.call(@report) if params["developer"].present?
    return Csv::BillingCsvService.call(@report) if params["billing"].present?
    return Csv::PerksCsvService.call(@report) if params["perks"].present?
    return Csv::InvoicesCsvService.call(@report) if params["invoice"].present?
    Csv::DevelopmentCsvService.call(@report)
  end
end
