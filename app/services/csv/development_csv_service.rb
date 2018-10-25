# frozen_string_literal: true

module Csv
  class DevelopmentCsvService < CsvService
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

    def self.headers
      [
        "Development name", "Plot number", "Phase", "Expiry date", "Resident email",
        "Resident name", "Resident invited on", "Resident invited by", "Resident role",
        "Resident activated", "Resident last sign in", "Lifetime sign in count",
        "Notifications #{@between}", "Developer updates", "Hoozzi updates", "Telephone updates",
        "Post updates", "Terms and conditions accepted", "Services subscribed"
      ]
    end

    def self.append_data(csv, development)
      csv << development_info(development)

      plots = development_plots(development)

      plots.each do |plot|
        csv << plot_info(plot) if plot.residents.empty?
        plot.residents.includes(:services).each do |resident|
          csv << plot_info(plot) + resident_info(resident,
                                                 resident.plot_residency_role_name(plot),
                                                 resident.plot_residency_invited_by(plot)&.email)
        end
      end
    end

    def self.development_info(development)
      [
        development.to_s,
        development.maintenance_link
      ]
    end

    def self.plot_info(plot)
      [
        "",
        plot.to_s,
        plot.phase.to_s,
        plot.expiry_date
      ]
    end

    def self.resident_info(resident, role, invited_by_email)
      [
        resident.email, resident.to_s,
        build_date(resident, "invitation_sent_at"), invited_by_email, role,
        build_date(resident, "invitation_accepted_at"), build_date(resident, "last_sign_in_at"),
        resident.sign_in_count, notification_count(resident.id),
        yes_or_no(resident, "developer_email_updates"),
        yes_or_no(resident, "cf_email_updates"),
        yes_or_no(resident, "telephone_updates"), yes_or_no(resident, "post_updates"),
        build_date(resident, "ts_and_cs_accepted_at"), build_services(resident)
      ]
    end

    def self.build_date(resident, column)
      return "" if resident.send(column).nil?
      I18n.l(resident.send(column).to_date, format: :digits)
    end

    def self.yes_or_no(resident, column)
      return "Yes" if resident.send(column).present? && resident.send(column).positive?
      "No"
    end

    def self.build_services(resident)
      service_array = resident.services.map(&:name)

      service_array.join(",")
    end

    def self.notification_count(resident_id)
      ResidentNotification.where(resident_id: resident_id)
                          .where(created_at: @from.beginning_of_day..@to.end_of_day)
                          .count
    end
  end
end
