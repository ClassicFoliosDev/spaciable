# frozen_string_literal: true

module Csv
  class BillingCsvService < CsvService
    def self.call(report)
      path = init(report, "billing")

      grouped_ordered_plots

      ::CSV.open(path, "w+", headers: true, return_headers: true) do |csv|
        csv << headers
        @plots.each do |plot|
          append_data(csv, plot)
        end
      end

      path
    end

    def self.grouped_ordered_plots
      @plots = Plot.none

      developers = Developer.all.order(:company_name)
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

    def self.headers
      [
        "Developer", "Division", "Development", "Phase", "Plot", "Legal completion date",
        "Reservation release date", "Completion release date", "Validity (months)",
        "Extended access (months)", "Expiry date", "Business", "BA4M enabled", "Services enabled",
        "Defects subscribed", "Residents invited", "Residents accepted", "Build progress"
      ]
    end

    def self.append_data(csv, plot)
      csv << plot_metadata(plot) + plot_info(plot) + plot_residents(plot)
    end

    def self.plot_metadata(plot)
      [
        plot.developer.to_s,
        division_name(plot),
        plot.development.to_s,
        plot.phase.to_s,
        plot.to_s
      ]
    end

    def self.plot_info(plot)
      [
        plot.completion_date,
        plot.reservation_release_date,
        plot.completion_release_date,
        plot.validity,
        plot.extended_access,
        plot.expiry_date,
        I18n.t("activerecord.attributes.phase.businesses.#{plot.business}"),
        plot.house_search,
        plot.enable_services?,
        plot.show_maintenance?
      ]
    end

    def self.plot_residents(plot)
      [
        plot.residents.count,
        plot.residents.where.not(invitation_accepted_at: nil).count,
        I18n.t("activerecord.attributes.plot.progresses.#{plot.progress}")
      ]
    end

    def self.division_name(plot)
      return plot.division.to_s if plot.division.present?
      "N/A"
    end
  end
end
