# frozen_string_literal: true

module Csv
  class DeveloperCsvService < CountCsvService
    def self.call(report)
      developer = Developer.find(report.developer_id)
      filename = build_filename(developer.to_s.parameterize.underscore)
      path = init(report, filename)

      ::CSV.open(path, "w+", headers: true, return_headers: true) do |csv|
        csv << headers
        append_data(csv, developer, true)
      end

      path
    end

    def self.headers
      [
        "Parent", "Name", "Plots created #{@between}", "Residents invited #{@between}",
        "Residents activated #{@between}", "Notifications #{@between}", "BestArea4Me enabled",
        "Services enabled", "Forum enabled", "Fixflo link", "Mailchimp list or segment id",
        "Developer emails accepted", "Hoozzi emails accepted", "Telephone accepted",
        "Post accepted", "Date created", "Last edited"
      ]
    end

    def self.append_data(csv, developer, with_developments)
      @plots_for_developer = plots_for("developer", developer.id)

      csv << developer_info(developer) if developer.divisions.count.zero?
      append_developments(csv, developer) if with_developments

      developer.divisions.each do |division|
        csv << division_info(division, division.developer)
        append_developments(csv, division) if with_developments
      end
    end

    def self.append_developments(csv, resource)
      resource.developments.each do |development|
        csv << development_info(development)
      end
    end

    def self.development_info(development)
      plots_for_development = plots_for("development", development.id)
      [
        development.parent.to_s, development.to_s, *count_fields(plots_for_development),
        notifications_in_range("Development", development.id), "", "", "",
        development.maintenance_link, development.segment_id,
        *mailchimp_fields(plots_for_development), *dates_for(development)
      ]
    end

    def self.division_info(division, developer)
      plots_for_division = plots_for("division", division.id)

      [
        division.parent.to_s, division.to_s, *count_fields(@plots_for_developer),
        notifications_in_range("Division", division.id), house_search(developer),
        developer.enable_services, developer.enable_development_messages, "", division.list_id,
        *mailchimp_fields(plots_for_division), *dates_for(division)
      ]
    end

    def self.developer_info(developer)
      [
        "DEVELOPER", developer.to_s, *count_fields(@plots_for_developer),
        notifications_in_range("Developer", developer.id), house_search(developer),
        developer.enable_services, developer.enable_development_messages, "", developer.api_key,
        *mailchimp_fields(@plots_for_developer), *dates_for(developer)
      ]
    end

    def self.house_search(developer)
      return "false" unless developer.house_search?
      developer.house_search
    end

    def self.notifications_in_range(resource_name, resource_id)
      Notification.where(send_to_type: resource_name).where(send_to_id: resource_id)
                  .where(created_at: @from.beginning_of_day..@to.end_of_day).count
    end

    def self.plots_for(resource_name, resource_id)
      type_query = Hash[resource_name, resource_id]
      Plot.where(type_query).eager_load(:residents)
    end
  end
end
