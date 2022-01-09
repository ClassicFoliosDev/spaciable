# frozen_string_literal: true

# rubocop:disable all
class DevelopmentCsv
  class << self

    CF_ONLY = 1
    ALL = 2

    COLUMNS = {
      phase: ALL,
      number: ALL,
      unit_type: CF_ONLY,
      uprn: ALL,
      prefix: ALL,
      house_number: ALL,
      building_name: ALL,
      road_name: ALL,
      postcode: ALL,
      completion_date: ALL,
      build_step: ALL,
      reservation_order_number: CF_ONLY,
      completion_order_number: CF_ONLY
    }


    def template(development)
      @file = Tempfile.new([development.identity, ".csv"], "tmp")
      @file.puts filtered_column_names.join(",")
      populate(development)
      @file.close
      @file
    end

    def filtered_column_names
      filtered_columns.map { |k, _| I18n.t("development_csv.#{k}") }
    end

    private

    def populate(development)
      development.phases.order(:name).each do | phase |
        next unless RequestStore.store[:current_user].cf_admin? || !phase.free?

        phase.plots.order(:number).each do | plot |
          @file.puts filtered_columns.map { |k, _| "\"#{datum(plot, k)}\"" }.join(",")
        end
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

    # filter the columns according to the current user role
    def filtered_columns
      COLUMNS.reject { |_, v| v == CF_ONLY && !RequestStore.store[:current_user].cf_admin? }
    end

  end
end
# rubocop:enable all
