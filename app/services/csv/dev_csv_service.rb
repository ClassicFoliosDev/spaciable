# frozen_string_literal: false

require "csv"

# rubocop:disable Metrics/ClassLength
module Csv
  class DevCsvService
    # fills in the fields with blank values where no resident is allocated to a plot
    NO_RESIDENT = (1..12).map { nil }

    def self.init(report, filename)
      @from = report.extract_date(report.report_from)
      @to = report.extract_date(report.report_to)
      @plot_types = report.plot_type

      formatted_from = I18n.l(@from.to_date, format: :digits)
      formatted_to = I18n.l(@to.to_date, format: :digits)

      Rails.root.join("tmp/#{filename}_#{formatted_from}_#{formatted_to}.csv")
    end

    def self.build_filename(file_name)
      now = I18n.l(Time.zone.now, format: :file_time)

      "#{now}_#{file_name}.csv"
    end

    def self.headers
      [
        "Developer", "Division", "Development", "Phase", "Plot", "Business",
        "Reservation Release", "Completion Release", "Validity", "Extended Access",
        "Expiry Date", "Legal Completion Date", "Build Progress", "Resident Count",
        "Resident Email", "Resident Name", "Resident Invited On", "Resident Invited By",
        "Resident Role", "Resident Activated", "Resident Last Sign In",
        "Lifetime Sign In Count", "Notifications", "Developer Updates", "Spaciable Updates",
        "Automated Emails", "Maintenance", "Services Enabled", "Referrals Enabled",
        "Referrals Count", "Snagging Enabled", "Snags Reported", "Snags Resolved",
        "Room Sketcher Enabled", "BestArea4Me Enabled", "Development FAQs"
      ]
    end

    def self.sort_plot_numbers(plots)
      plot_array = plots.sort
      ids = plot_array.map(&:id)

      Plot.where(id: ids).order("position(id::text in '#{ids.join(',')}')")
    end

    def self.plot_info(plot)
      [
        plot.company_name, plot_division(plot), plot.development_name,
        plot.phase.to_s, plot.number,
        I18n.t("activerecord.attributes.phase.businesses.#{plot.business}"),
        build_date(plot, "reservation_release_date"),
        build_date(plot, "completion_release_date"),
        plot.validity, plot.extended_access,
        plot_expiry_date(plot),
        build_date(plot, "completion_date"),
        I18n.t("activerecord.attributes.plot.progresses.#{plot.progress}")
      ]
    end

    def self.resident_info(plot, resident, resident_number)
      [
        resident_number, resident.email, resident.to_s,
        build_date(resident, "invitation_created_at"),
        resident.plot_residency_invited_by(plot)&.email,
        resident.plot_residency_role_name(plot),
        build_date(resident, "invitation_accepted_at"),
        build_date(resident, "last_sign_in_at"),
        resident.sign_in_count, notification_count(resident.id),
        yes_or_no(resident, "developer_email_updates"),
        yes_or_no(resident, "cf_email_updates")
      ]
    end

    def self.summary_info(plot, resident = nil)
      [
        yes_or_no(plot.developer, "api_key"),
        plot.maintenance_link, yes_or_no(plot.developer, "enable_services"),
        yes_or_no(plot.developer, "enable_referrals"), referrals_count(resident),
        yes_or_no(plot.development, "enable_snagging"), plot.all_snags_count,
        plot.resolved_snags_count,
        yes_or_no(plot.developer, "enable_roomsketcher"),
        yes_or_no(plot.developer, "house_search"),
        yes_or_no(plot.developer, "development_faqs")
      ]
    end

    def self.referrals_count(resident)
      return 0 if resident.nil?
      resident.referrals_count
    end

    def self.get_plot_types(plots)
      if @plot_types == "res"
        plots.where(reservation_release_date: @from.beginning_of_day..@to.end_of_day)
             .where(completion_release_date: nil)
      elsif @plot_types == "comp"
        plots.where(completion_release_date: @from.beginning_of_day..@to.end_of_day)
      else
        plots.where('(completion_release_date BETWEEN :start_at AND :end_at) OR
                    (reservation_release_date BETWEEN :start_at AND :end_at)',
                    start_at: @from.beginning_of_day, end_at: @to.end_of_day)
      end
    end

    def self.build_date(record, column)
      return "" if record.send(column).nil?
      record.send(column).strftime("%d/%m/%Y")
    end

    def self.notification_count(resident_id)
      ResidentNotification.where(resident_id: resident_id)
                          .where(created_at: @from.beginning_of_day..@to.end_of_day)
                          .count
    end

    def self.plot_expiry_date(plot)
      plot.expiry_date ? plot.expiry_date.strftime("%m/%d/%Y") : ""
    end

    def self.yes_or_no(record, column)
      return "Yes" if record.send(column) == true
      return "Yes" if record.send(column).present? && record.send(column).positive?
      "No"
    end

    def self.plot_division(plot)
      plot.division_name if plot.division
    end
  end
end
# rubocop:enable Metrics/ClassLength
