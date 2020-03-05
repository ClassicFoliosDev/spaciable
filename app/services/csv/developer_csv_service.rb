# frozen_string_literal: true

module Csv
  class DeveloperCsvService < DevCsvService
    # rubocop:disable Metrics/MethodLength
    def self.call(report)
      paths = []
      developers = if report.developer_id == I18n.t(".lists.all_value")
                     Developer.all
                   else
                     [Developer.find(report.developer_id)]
                   end

      developers.each do |developer|
        filename = build_filename(developer.to_s.parameterize.underscore)
        paths << init(report, filename)

        ::CSV.open(paths.last, "w+", headers: true, return_headers: true) do |csv|
          csv << headers
          append_data(csv, developer)
        end
      end

      paths
    end
    # rubocop:enable Metrics/MethodLength

    def self.append_data(csv, developer)
      plots = developer_plots(developer)

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

    # an array of plots under the developer
    def self.developer_plots(developer)
      phases = sorted_phases(developer)
      plots = Plot.none
      phases.each do |phase|
        unsorted_plots = get_plot_types(phase.plots)
        plots += sort_plot_numbers(unsorted_plots)
      end

      plots
    end

    def self.sorted_phases(developer)
      developer.phases.order(:development_id, :name)
    end
  end
end
