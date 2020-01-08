# frozen_string_literal: true

module Csv
  class AllDeveloperCsvService < SummaryCsvService
    def self.call(report)
      filename = build_filename("all_developers_summary")
      path = init(report, filename)

      developers = Developer.where(created_at: @from.beginning_of_day..@to.end_of_day)

      ::CSV.open(path, "w+", headers: true, return_headers: true) do |csv|
        csv << headers
        developers.each do |developer|
          append_data(csv, developer)
        end
      end

      path
    end

    def self.headers
      [
        "Developer", "Division", "Developments Count", "Phases Count", "Active Plots",
        "Expired Plots", "Reservation Plots", "Completion Plots", "Residents Invited",
        "Residents Activated", "Admins Invited", "Admins Activated", "Notifications Sent",
        "Developer Emails Accepted", "Spaciable Emails Accepted", "Automated Emails",
        "Home Designer Enabled", "BestArea4Me Enabled", "Forum Enabled", "Development FAQs",
        "Referrals Enabled", "Services Enabled", "Maintenance Link Count",
        "Snagging Enabled Count", "Snags Recorded", "Snags Resolved", "Core Phases",
        "NHBC Phases", "Migrated Phases", "Date Created", "Last Edited"
      ]
    end

    def self.append_data(csv, developer)
      if developer.divisions.count.zero?
        csv << [developer.company_name, ""] + overview_info(developer) + child_info(developer)
      else
        developer.divisions.each do |division|
          csv << [developer.company_name, division.to_s] + overview_info(division) +
                 child_info(division)
        end

      end
    end

    def self.overview_info(parent)
      [
        parent.developments.count, parent.phases.count,
        active_plots_count(parent), expired_plots_count(parent),
        reservation_plots_count(parent), completion_plots_count(parent),
        parent.residents.count, activated_resident_count(parent),
        admin_count(parent), activated_admin_count(parent),
        notification_count(parent)
      ]
    end

    def self.child_info(parent)
      [
        developer_emails_count(parent), spaciable_emails_count(parent),
        yes_or_no(parent, "api_key"),
        yes_or_no(parent, "enable_roomsketcher"), yes_or_no(parent, "house_search"),
        yes_or_no(parent, "enable_development_messages"),
        yes_or_no(parent, "development_faqs"), yes_or_no(parent, "enable_referrals"),
        yes_or_no(parent, "enable_services"),
        maintenance_count(parent), snagging_enabled_count(parent),
        total_snags_count(parent), resolved_snags_count(parent),
        phases_business_count(parent, "core"), phases_business_count(parent, "nhbc"),
        phases_business_count(parent, "mhf"),
        build_date(parent, "created_at"), build_date(parent, "updated_at")
      ]
    end
  end
end
