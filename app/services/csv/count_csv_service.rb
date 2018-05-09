# frozen_string_literal: true

module Csv
  class CountCsvService < CsvService
    def self.mailchimp_fields(residents_for_resource)
      [
        updates_for(residents_for_resource, "developer_email_updates"),
        updates_for(residents_for_resource, "hoozzi_email_updates"),
        updates_for(residents_for_resource, "telephone_updates"),
        updates_for(residents_for_resource, "post_updates")
      ]
    end

    def self.updates_for(residents_for_resource, update_type)
      count = 0
      residents_for_resource.each do |resident|
        count += 1 if resident.send(update_type).present?
      end

      count
    end

    def self.count_fields(residents_for_resource)
      [
        residents_in_range(residents_for_resource),
        activated_residents_in_range(residents_for_resource)
      ]
    end

    def self.plots_in_range(plots_for_resource)
      count = 0
      plots_for_resource.each do |plot|
        count += 1 if plot.created_at.between?(@from.beginning_of_day, @to.end_of_day)
      end

      count
    end

    def self.residents_in_range(residents_for_resource)
      count = 0
      residents_for_resource.each do |resident|
        count += 1 if resident.created_at.between?(@from.beginning_of_day, @to.end_of_day)
      end

      count
    end

    def self.activated_residents_in_range(residents_for_resource)
      count = 0
      residents_for_resource.each do |resident|
        count += 1 if resident.invitation_accepted_at? &&
                      resident.created_at.between?(@from.beginning_of_day, @to.end_of_day)
      end

      count
    end

    def self.count_services(residents_for_resource)
      count = 0
      residents_for_resource.each do |resident|
        count += 1 if ResidentService.find_by(resident_id: resident.id).present?
      end

      count
    end
  end
end
