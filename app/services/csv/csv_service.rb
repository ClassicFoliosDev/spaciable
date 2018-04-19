# frozen_string_literal: false

require "csv"

module Csv
  class CsvService
    def self.build_filename(file_name)
      now = I18n.l(Time.zone.now, format: :file_time)

      "#{now}_#{file_name}.csv"
    end
  end
end
