# frozen_string_literal: false

require "csv"

module Csv
  class CsvService
    def self.build_filename(file_name)
      now = I18n.l(Time.zone.now, format: :file_time)

      "#{now}_#{file_name}.csv"
    end

    def self.init(report, filename)
      @from = report.extract_date(report.report_from)
      @to = report.extract_date(report.report_to)

      formatted_from = I18n.l(@from.to_date, format: :digits)
      formatted_to = I18n.l(@to.to_date, format: :digits)
      @between = "between #{formatted_from} and #{formatted_to}"

      Rails.root.join("tmp/#{filename}_#{formatted_from}_#{formatted_to}.csv")
    end

    def self.dates_for(resource)
      [
        I18n.l(resource.created_at.to_date, format: :digits),
        I18n.l(resource.updated_at.to_date, format: :digits)
      ]
    end

    def self.development_plots(development)
      phases = development.phases.order(:name)
      plots = Plot.none
      phases.each do |phase|
        unsorted_plots = phase.plots.where(created_at: @from.beginning_of_day..@to.end_of_day)
        plots += sort_plot_numbers(unsorted_plots)
      end

      plots
    end

    def self.sort_plot_numbers(plots)
      plot_array = plots.sort
      ids = plot_array.map(&:id)

      Plot.where(id: ids).order("position(id::text in '#{ids.join(',')}')")
    end
  end
end
