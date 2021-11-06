# frozen_string_literal: true

# rubocop:disable all
class DevelopmentCsv
  class << self

    COLUMNS = %w[phase
                 number
                 uprn
                 prefix
                 house_number
                 building_name
                 road_name
                 postcode
                 completion_date
                 build_step
                ]

    def template(development)
      @file = Tempfile.new(["development", ".csv"], "tmp")
      @file.puts COLUMNS.map { |c| I18n.t("development_csv.#{c}") }.join(",")
      populate(development)
      @file.close
      @file
    end

    private

    def populate(development)
      plots = Plot.joins(phase: :development).where(developments: {id: 32 }).order("phases.name, plots.number")
      plots.each do |plot|
        @file.puts COLUMNS.map { |c| datum(plot, c) }.join(",")
      end
    end

    def datum(plot, column)
      value = plot.send(column)
      return "" if value.nil?

      case value.class.to_s
        when "Date", "String"
          return value
        else
          return value.identity
      end
    end

  end
end
# rubocop:enable all
