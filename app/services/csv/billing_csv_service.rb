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

    def self.headers
      [
        "Developer", "Division", "Development", "Phase", "Plot",
        "Business Stream", "Reservation Order Number", "Completion Order Number",
        "Reservation Release Date", "Completion Release Date",
        "Validity", "Extended Access", "Expiry Date", "Expired",
        "Maintenance", "Residents Invited", "Residents Accepted"

      ]
    end

    def self.append_data(csv, plot)
      csv << plot_metadata(plot) + plot_info(plot) + plot_residents(plot)
    end

    def self.plot_metadata(plot)
      [
        plot.company_name,
        division_name(plot),
        plot.development_name,
        plot.phase_name,
        plot.number
      ]
    end

    def self.plot_info(plot)
      [
        I18n.t("activerecord.attributes.phase.businesses.#{plot.business}"),
        plot.reservation_order_number,
        plot.completion_order_number,
        build_date(plot, "reservation_release_date"),
        build_date(plot, "completion_release_date"),
        plot.validity,
        plot.extended_access,
        expiry_date(plot),
        expired_status(plot),
        maintenance_type(plot)
      ]
    end

    def self.plot_residents(plot)
      [
        plot.residents.count,
        plot.residents.where.not(invitation_accepted_at: nil).count
      ]
    end

    def self.maintenance_type(plot)
      return unless plot&.maintenance&.account_type
      I18n.t("activerecord.attributes.maintenance.account_types.#{plot.maintenance.account_type}")
    end
  end
end
