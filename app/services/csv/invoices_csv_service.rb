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
        "Development", "Phase", "Package", "Package Plots", "FF Plots"
      ]
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def self.append_invoices(report, csv)
      ff_plots = 0
      prev_invoice = nil

      Invoice.by_phase(report.extract_date(report.report_from),
                       report.extract_date(report.report_to),
                       report.developer_id == "*" ? nil : report.developer_id,
                       report.division_id,
                       report.development_id).each do |invoice|

        if prev_invoice.present? &&
           (prev_invoice.created_at != invoice.created_at ||
            prev_invoice.phase.developer.id != invoice.phase.developer.id)
          csv << Csv::CsvService.empty_line(headers.length)
          if ff_plots.present? && ff_plots.positive?
            csv << [prev_invoice.created_at,
                    prev_invoice.phase.developer.identity, nil, nil, nil, nil, nil, ff_plots]
            csv << Csv::CsvService.empty_line(headers.length)
          end

          ff_plots = 0
        end

        csv << [invoice.created_at,
                invoice.phase.developer.identity,
                invoice.phase&.division&.identity,
                invoice.phase.development.identity,
                invoice.phase.identity,
                I18n.t("activerecord.attributes.phase.packages.#{invoice.package}"),
                invoice.plots,
                invoice.ff_plots]

        ff_plots += invoice.ff_plots if invoice.ff_plots.present?
        prev_invoice = invoice
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
