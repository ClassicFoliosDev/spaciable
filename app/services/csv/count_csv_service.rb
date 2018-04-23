# frozen_string_literal: true

module Csv
  class CountCsvService < CsvService
    def self.mailchimp_fields(plots_for_resource)
      [
        updates_for(plots_for_resource, "developer_email_updates"),
        updates_for(plots_for_resource, "hoozzi_email_updates"),
        updates_for(plots_for_resource, "telephone_updates"),
        updates_for(plots_for_resource, "post_updates")
      ]
    end

    def self.updates_for(plots_for_resource, update_type)
      count = 0
      plots_for_resource.each do |plot|
        plot.residents.each do |resident|
          count += 1 if resident.send(update_type).present?
        end
      end

      count
    end

    def self.count_fields(plots_for_resource)
      [
        plots_in_range(plots_for_resource),
        residents_in_range(plots_for_resource),
        activated_residents_in_range(plots_for_resource)
      ]
    end

    def self.plots_in_range(plots_for_resource)
      count = 0
      plots_for_resource.each do |plot|
        count += 1 if plot.created_at.between?(@from.beginning_of_day, @to.end_of_day)
      end

      count
    end

    def self.residents_in_range(plots_for_resource)
      count = 0
      plots_for_resource.each do |plot|
        plot.residents.each do |resident|
          count += 1 if resident.created_at.between?(@from.beginning_of_day, @to.end_of_day)
        end
      end

      count
    end

    def self.activated_residents_in_range(plots_for_resource)
      count = 0
      plots_for_resource.each do |plot|
        plot.residents.each do |resident|
          count += 1 if resident.invitation_accepted_at? &&
                        resident.created_at.between?(@from.beginning_of_day, @to.end_of_day)
        end
      end

      count
    end
  end
end
