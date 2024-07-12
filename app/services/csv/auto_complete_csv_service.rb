# frozen_string_literal: true

module Csv
  class AutoCompleteCsvService < SummaryCsvService
    def self.call(plots)
      filename = build_filename("auto_complete_summary")
      path = Rails.root.join("tmp/#{filename}")

      ::CSV.open(path, "w+", headers: true, return_headers: true) do |csv|
        csv << headers
        plots.each { |plot| append_data(csv, plot) }
      end

      path
    end

    def self.headers
      %w[Developer Development Phase Plot]
    end

    def self.append_data(csv, plot)
      csv << [
        plot.developer.company_name,
        plot.development.name,
        plot.phase.name,
        plot.number
      ]
    end
  end
end
