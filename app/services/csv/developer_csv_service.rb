# frozen_string_literal: true

module Csv
  class DeveloperCsvService < DevCsvService
    # rubocop:disable Metrics/MethodLength
    def self.call(report)
      if report.developer_id == I18n.t(".lists.all_value")
        developers = Developer.where(is_demo: false)
        filename = build_filename("all_developers")
      else
        developers = [Developer.find(report.developer_id)]
        filename = build_filename(developers[0].to_s.parameterize.underscore)
      end

      path = init(report, filename)
      ::CSV.open(path, "w+", headers: true, return_headers: true) do |csv|
        csv << headers
        developers.each do |developer|
          append_data(csv, developer)
        end
      end

      path
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
