# frozen_string_literal: true

require "csv"

module Csv
  class ChoicesCsvService
    def self.call(plot)
      filename = "Plot #{plot.number} Choices-#{Time.zone.today.strftime('%d %B %Y')}"
      path = Rails.root.join("tmp/#{filename}.csv")

      attributes = %w[room name full_name]
      CSV.generate(headers: true) do |csv|
        csv << attributes
        plot.room_choices.each do |choice|
          csv << attributes.map { |attr| choice.send(attr) }
        end
      end

      path
    end
  end
end
