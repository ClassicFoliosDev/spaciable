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
      @plot_types = report.plot_type

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

    # An admin uses the Plot Release Type dropdown to return plots with a completion
    # release date or a reservation release date (or both) between the selected date range
    # rubocop:disable Metrics/MethodLength
    def self.get_plot_types(plots)
      if @plot_types == "res"
        plots.where(reservation_release_date: @from.beginning_of_day..@to.end_of_day)
             .where(completion_release_date: nil)
      elsif @plot_types == "comp"
        plots.where(completion_release_date: @from.beginning_of_day..@to.end_of_day)
      elsif @plot_types == "created"
        plots.where('(reservation_release_date BETWEEN :start_at AND :end_at) OR
                    ((completion_release_date BETWEEN :start_at AND :end_at) AND
                     (reservation_release_date IS NULL))',
                    start_at: @from.beginning_of_day, end_at: @to.end_of_day)
      elsif @plot_types == "expired"
        expired = []
        plots.each { |p| expired << p if p.expiry_date && (@from..@to).cover?(p.expiry_date) }
        expired
      else
        plots.where('(completion_release_date BETWEEN :start_at AND :end_at) OR
                    (reservation_release_date BETWEEN :start_at AND :end_at)',
                    start_at: @from.beginning_of_day, end_at: @to.end_of_day)
      end
    end
    # rubocop:enable Metrics/MethodLength

    def self.grouped_ordered_plots
      @plots = Plot.none

      developers = Developer.where(is_demo: false).order(:company_name)
      developers.each do |developer|
        developments_no_division = developer.developments.where(division_id: nil).order(:name)
        developments_plots(developments_no_division)

        divisions = developer.divisions.order(:division_name)
        divisions.each do |division|
          developments = division.developments.order(:name)
          developments_plots(developments)
        end
      end

      @plots
    end

    def self.developments_plots(developments)
      developments.each do |development|
        @plots += development_plots(development)
      end
    end

    def self.development_plots(development)
      phases = development.phases.order(:name)
      plots = Plot.none
      phases.each do |phase|
        unsorted_plots = get_plot_types(phase.plots)
        plots += sort_plot_numbers(unsorted_plots)
      end

      plots
    end

    def self.sort_plot_numbers(plots)
      plot_array = plots.sort
      ids = plot_array.map(&:id)

      Plot.where(id: ids).order("position(id::text in '#{ids.join(',')}')")
    end

    def self.division_name(plot)
      plot.division.present? ? plot.division_name : ""
    end

    def self.build_date(record, column)
      return "" if record.send(column).nil?

      record.send(column).strftime("%d/%m/%Y")
    end

    # This is being temperamental on Staging, keep an eye on it
    def self.expired_status(plot)
      return "" unless plot.completion_release_date

      plot.expired? ? "Expired" : "Active"
    end

    def self.expiry_date(plot)
      plot.expiry_date&.strftime("%d/%m/%Y")
    end

    def self.empty_line(entries)
      Array.new(entries) { |_| nil }
    end
  end
end
