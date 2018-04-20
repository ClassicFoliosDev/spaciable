# frozen_string_literal: true

module Csv
  class AllDeveloperCsvService < DeveloperCsvService
    def self.call(report)
      developers = Developer.all.includes(:divisions)
      filename = build_filename("all_developers_summary")
      path = Rails.root.join("tmp/#{filename}")

      @from = report.extract_date(report.report_from)
      @to = report.extract_date(report.report_to)

      ::CSV.open(path, "w+", headers: true, return_headers: true) do |csv|
        csv << headers
        developers.each do |developer|
          append_data(csv, developer, false)
        end
      end

      path
    end
  end
end
