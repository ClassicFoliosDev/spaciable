# frozen_string_literal: false

require "csv"

# rubocop:disable Metrics/ClassLength
module Csv
  class DevCsvService
    # fills in the fields with blank values where no resident is allocated to a plot
    NO_RESIDENT = (1..13).map { nil }

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
        "Account Manager", "Developer", "Division", "Development", "Phase", "Plot", "Business",
        "Reservation Order", "Completion Order", "Reservation Release", "Completion Release",
        "Validity", "Extended Access", "Expiry Date", "Legal Completion Date", "Build Progress",
        "Resident Count", "Resident Email", "Resident Name", "Resident Invited On",
        "Resident Invited By", "Resident Role", "Resident Activated", "Resident Last Accessed At",
        "Lifetime Sign In Count", "Notifications", "Developer Emails", "Spaciable Emails",
        "Spaciable Texts", "Automated Emails", "Maintenance", "Services Enabled",
        "Referrals Enabled", "Referrals Count",
        "Snagging Enabled", "Snagging duration", "Snags Reported", "Snags Resolved",
        "Buyers Club Enabled", "Licenses Bought", "Licences Remaining", "Perks Requested",
        "Home Designer Enabled", "BestArea4Me Enabled", "Development FAQs", "Calendar",
        "My Journey", "Content Proforma", "Build Progress List", "Spaciable Legal"
      ]
    end

    def self.sort_plot_numbers(plots)
      plot_array = plots.sort
      ids = plot_array.map(&:id)

      Plot.where(id: ids).order("position(id::text in '#{ids.join(',')}')")
    end

    def self.plot_info(plot)
      [
        plot.account_manager_name,
        plot.company_name, plot_division(plot), plot.development_name,
        plot.phase.to_s, plot.number,
        I18n.t("activerecord.attributes.phase.businesses.#{plot.business}"),
        plot.reservation_order_number, plot.completion_order_number,
        build_date(plot, "reservation_release_date"),
        build_date(plot, "completion_release_date"),
        plot.validity, plot.extended_access,
        plot_expiry_date(plot),
        build_date(plot, "completion_date"),
        plot.build_step_title
      ]
    end

    def self.resident_info(plot, resident, resident_number)
      last_event = Ahoy::Event.where(userable: resident).order(:time).last
      [
        resident_number, resident.email, resident.to_s,
        build_date(resident, "invitation_created_at"),
        resident.plot_residency_invited_by(plot)&.email,
        resident.plot_residency_role_name(plot),
        build_date(resident, "invitation_accepted_at"),
        last_event&.time&.strftime("%d/%m/%Y"),
        resident.sign_in_count, notification_count(resident.id),
        yes_or_no(resident, "developer_email_updates"),
        yes_or_no(resident, "cf_email_updates"),
        yes_or_no(resident, "telephone_updates")
      ]
    end

    # rubocop:disable all
    def self.summary_info(plot, resident = nil)
      [
        yes_or_no(plot.developer, "api_key"),
        maintenance_type(plot),
        yes_or_no(plot.developer, "enable_services"),
        yes_or_no(plot.developer, "enable_referrals"), referrals_count(resident),
        enabled?(plot, plot.development, "enable_snagging"),
        plot.snag_duration,
        plot.all_snags_count,
        plot.resolved_snags_count,
        enabled?(plot, plot.developer, "enable_perks"),
        plot.development_premium_licences_bought,
        Vaboo.available_premium_licences(plot.development),
        Vaboo.perk_type_registered(resident, plot),
        enabled?(plot, plot.developer, "enable_roomsketcher"),
        yes_or_no(plot.developer, "house_search"),
        yes_or_no(plot.developer, "development_faqs"),
        plot.development_calendar ? "Yes" : "No",
        plot.journey ? plot.journey.title : "No",
        plot.proformas.count.positive?  ? plot.proformas.count : "No",
        plot.build_sequenceable_type,
        plot.conveyancing_enabled? ? "Yes" : "No"
      ]
    end
    # rubocop:enable all

    def self.enabled?(plot, record, field)
      return "No" if plot.free? || plot.essentials?
      yes_or_no(record, field)
    end

    def self.referrals_count(resident)
      return 0 if resident.nil?
      resident.referrals_count
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
      plot.expiry_date ? plot.expiry_date.strftime("%d/%m/%Y") : ""
    end

    def self.yes_or_no(record, column)
      return "Yes" if record.send(column) == true
      return(record.send(column).positive? ? "Yes" : "No") if record.send(column).is_a? Integer
      return "Yes" if record.send(column).present? # if not boolean or integer, check for a value
      "No"
    end

    def self.plot_division(plot)
      plot.division_name if plot.division
    end

    def self.maintenance_type(plot)
      return unless plot&.maintenance&.account_type
      I18n.t("activerecord.attributes.maintenance.account_types.#{plot.maintenance.account_type}")
    end
  end
end
# rubocop:enable Metrics/ClassLength
