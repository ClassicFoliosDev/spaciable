# frozen_string_literal: true

module Csv
  class DeveloperCsvService < CsvService
    def self.call(report)
      developer = Developer.find(report.developer_id)
      filename = build_filename(developer.to_s.parameterize.underscore)
      path = Rails.root.join("tmp/#{filename}")

      ::CSV.open(path, "w+", headers: true, return_headers: true) do |csv|
        csv << headers
        append_data(csv, developer, report, true)
      end

      path
    end

    def self.headers
      [
        "Company name", "Division name", "Development name",
        "Plots count", "Residents count", "Activated residents count",
        "BestArea4Me enabled", "Services enabled", "Forum enabled",
        "Fixflo link", "Mailchimp API key", "Date created", "Last edited"
      ]
    end

    def self.append_data(csv, developer, report, with_developments)
      @from = report.extract_date(report.report_from)
      @to = report.extract_date(report.report_to)

      csv << developer_info(developer)
      append_developments(csv, developer) if with_developments

      developer.divisions.each do |division|
        csv << division_info(division)
        append_developments(csv, division) if with_developments
      end
    end

    def self.append_developments(csv, resource)
      resource.developments.each do |development|
        csv << development_info(development)
      end
    end

    def self.development_info(development)
      [
        "", development&.division&.to_s, development.to_s,
        plots_for("development_id", development.id),
        residents_for("development_id", development.id),
        activated_residents_for("development_id", development.id),
        "", "", "",
        development.maintenance_link, development.segment_id,
        I18n.l(development.created_at.to_date, format: :digits),
        I18n.l(development.updated_at.to_date, format: :digits)
      ]
    end

    def self.division_info(division)
      [
        "", division.to_s, "",
        "", "", "",
        "", "", "", "",
        division.list_id,
        I18n.l(division.created_at.to_date, format: :digits),
        I18n.l(division.updated_at.to_date, format: :digits)
      ]
    end

    def self.developer_info(developer)
      [
        developer.to_s, "", "",
        plots_for("developer_id", developer.id),
        residents_for("developer_id", developer.id),
        activated_residents_for("developer_id", developer.id),
        developer.house_search, developer.enable_services,
        developer.enable_development_messages, "", developer.api_key,
        I18n.l(developer.created_at.to_date, format: :digits),
        I18n.l(developer.updated_at.to_date, format: :digits)
      ]
    end

    def self.plots_for(resource_name, resource_id)
      query = Hash[resource_name, resource_id]
      plots = Plot.where(query).where(created_at: @from.beginning_of_day..@to.end_of_day)

      plots.count
    end

    def self.residents_for(resource_name, resource_id)
      query = Hash[resource_name, resource_id]
      plots = Plot.where(query)
      plot_residents = plots.map do |plot|
        plot.residents.where(created_at: @from.beginning_of_day..@to.end_of_day).count
      end

      plot_residents.sum
    end

    def self.activated_residents_for(resource_name, resource_id)
      type_query = Hash[resource_name, resource_id]
      plots = Plot.where(type_query)
      plot_residents = plots.map do |plot|
        plot.residents.where.not(invitation_accepted_at: nil)
            .where(invitation_accepted_at: @from.beginning_of_day..@to.end_of_day).count
      end

      plot_residents.sum
    end
  end
end
