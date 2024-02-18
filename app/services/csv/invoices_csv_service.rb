# frozen_string_literal: true

module Csv
  class InvoicesCsvService
    def self.call(report)
      filename = build_filename("invoices_summary")
      path = init(report, filename)

      ::CSV.open(path, "w+", headers: true, return_headers: true) do |csv|
        csv << headers
        append_invoices(report, csv)
      end

      path
    end

    def self.init(report, filename)
      @from = report.extract_date(report.report_from)
      @to = report.extract_date(report.report_to)

      formatted_from = I18n.l(@from.to_date, format: :digits)
      formatted_to = I18n.l(@to.to_date, format: :digits)

      Rails.root.join("tmp/#{filename}_#{formatted_from}_#{formatted_to}.csv")
    end

    def self.build_filename(file_name)
      now = I18n.l(Time.zone.now, format: :file_time)
      "#{now}_#{file_name}.csv"
    end

    def self.headers
      [
        "Creation Date", "Developer", "Division",
        "Development", "Phase", "Package", "CPP", "Package Plots"
      ]
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def self.append_invoices(report, csv)
      Invoice.by_phase(report.extract_date(report.report_from),
                       report.extract_date(report.report_to),
                       report.developer_id == "*" ? nil : report.developer_id,
                       report.division_id,
                       report.development_id).each do |invoice|
        csv << [invoice.created_at,
                invoice.phase.developer.identity,
                invoice.phase&.division&.identity,
                invoice.phase.development.identity,
                invoice.phase.identity,
                I18n.t("activerecord.attributes.phase.packages.#{invoice.package}"),
                invoice.cpp,
                invoice.plots]

        next unless invoice.ff_plots&.positive?

        csv << [invoice.created_at,
                invoice.phase.developer.identity,
                invoice.phase&.division&.identity,
                invoice.phase.development.identity,
                invoice.phase.identity,
                "FixFlo",
                invoice.ff_plots]
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
