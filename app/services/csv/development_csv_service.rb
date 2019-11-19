# frozen_string_literal: true

module Csv
  class DevelopmentCsvService < DevCsvService
    def self.call(report)
      development = Development.find(report.development_id)
      filename = build_filename(development.to_s.parameterize.underscore)
      path = init(report, filename)

      ::CSV.open(path, "w+", headers: true, return_headers: true) do |csv|
        csv << headers
        append_data(csv, development)
      end

      path
    end

    def self.append_data(csv, development)
      plots = development_plots(development)

      plots.each do |plot|
        csv << plot_info(plot) + NO_RESIDENT + summary_info(plot) if plot.residents.empty?

        resident_number = 0
        plot.residents.sort_by(&:email).each do |resident|
          resident_number += 1
          csv << plot_info(plot) + resident_info(plot, resident, resident_number.to_s) +
                 summary_info(plot, resident)
        end
      end
    end

    # an array of plots under the development
    def self.development_plots(development)
      phases = development.phases.order(:name)
      plots = Plot.none
      phases.each do |phase|
        unsorted_plots = get_plot_types(phase.plots)
        plots += sort_plot_numbers(unsorted_plots)
      end

      plots
    end
  end
end
