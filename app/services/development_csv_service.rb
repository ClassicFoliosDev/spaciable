# frozen_string_literal: true

module DevelopmentCsvService
  module_function

  PHASE = 0
  PLOT = 1
  UNIT = 2
  PREFIX = 3
  HOUSE_NUMBER = 4
  BUILDING_NAME = 5
  ROAD_NAME = 6
  POSTCODE = 7
  LEGAL_COMP_DATE = 8
  PROGRESS = 9

  require "date"

  def call(file, development, flash)
    return notify_type_error(flash) unless correct_content_type(file) # check the file type

    # Use a hash of arrays to store error messages
    @errors = { phase: [], plot: [], unit: [], completion: [], progress: [], duplicate: [] }
    @success_plots = []
    import(file, development)
    notify_errors
    notify_success(@success_plots)
    notify_flash(flash) # display the relevant errors or notice
  end

  # check the file type is valid
  def correct_content_type(file)
    acceptable_types = ["text/csv", "text/x-csv", "application/vnd.ms-excel", "application/csv",
                        "application/x-csv", "text/comma-separated-values",
                        "text/x-comma-separated-values"]
    acceptable_types.include? file.content_type.chomp
  end

  # the loop will exit once an error is encountered, so will not check any further fields,
  # meaning only the first found error for each plot will be stored for the alert
  # rubocop:disable all
  def import(file, development)
    CSV.foreach(file.path, headers: true) do |row|
      # find the phase from development and store an error if it does not exist
      phase_id = Phase.find_by(development_id: development.id, name: row[PHASE])
      @errors[:phase] << (row[PHASE] unless @errors[:phase].include?(row[PHASE])) && next unless phase_id

      # find the plot from phase and store an error if it does not exist
      plot = Plot.find_by(phase_id: phase_id.id, number: row[PLOT])
      @errors[:plot] << (row[PLOT]) && next unless plot

      # store an error if the plot number is duplicated in the CSV
      # if a previous instance of the plot was successfully saved then those values will remain
      # if a previous instance of the plot was unsuccessful then the duplicate plot attributes will
      # not be updated, even if they are valid
      @errors[:duplicate] << (row[PLOT]) && next if @errors[:plot].include?(row[PLOT]) || @success_plots.include?(row[PLOT])

      # check the unit type exists and store an error if it does not
      if row[UNIT].present?
        unit_id = UnitType.find_by(development_id: development.id, name: row[UNIT])
        @errors[:unit] << (row[UNIT] unless @errors[:unit].include?(row[UNIT])) && next unless unit_id
        plot.unit_type_id = unit_id.id
      end

      # update plot address information, leave unchanged if field is blank
      plot.prefix = row[PREFIX] if row[PREFIX].present?
      plot.house_number = row[HOUSE_NUMBER] if row[HOUSE_NUMBER].present?
      plot.building_name = row[BUILDING_NAME] if row[BUILDING_NAME].present?
      plot.road_name = row[ROAD_NAME] if row[ROAD_NAME].present?
      plot.postcode = row[POSTCODE] if row[POSTCODE].present?

      # check the legal completion date is in date format and within the specified range
      # and store an error if it is not
      if row[LEGAL_COMP_DATE].present?
        begin Date.parse(row[LEGAL_COMP_DATE])
          date = Date.parse(row[LEGAL_COMP_DATE])
          if (date < (Time.zone.today - 6.months)) || (date > (Time.zone.today + 1.year))
            @errors[:completion] << plot.number && next
          end
          plot.completion_date = date
        rescue
          @errors[:completion] << plot.number && next
        end
      end

      # check the build progress is valid and store an error if it is not
      if row[9].present?
        unless Plot.progresses.include?(row[PROGRESS])
          @errors[:progress] << (row[PROGRESS] unless @errors[:progress].include?(row[PROGRESS])) && next
        end
        plot.progress = row[PROGRESS]
      end

      plot.save!
      @success_plots << plot.number # store the successful plot number for notifying
    end
  end
  # rubocop:enable all

  # build the success notice
  def notify_success(success_plots)
    success_plots = success_plots.join(", ")
    @notice = if success_plots.present?
                I18n.t("development_csv.errors.success", plots: success_plots)
              end
  end

  # error message for incorrect file type
  def notify_type_error(flash)
    flash[:alert] = I18n.t("development_csv.errors.file_type")
  end

  # build the error alert
  def notify_errors
    all_errors = @errors.reject { |k, v| get_errors(k, v).nil? }.map { |k, v| get_errors(k, v) }
    message = all_errors.join(" ")
    @alert = if all_errors.present?
               # rubocop:disable all
               I18n.t("development_csv.errors.overview", errors: message).html_safe
               # rubocop:enable all
             end
  end

  def notify_flash(flash)
    flash[:alert] = unless @alert.present? || @notice.present?
                      I18n.t("development_csv.errors.no_plots")
                    end
    flash[:alert] = @alert if @alert.present?
    flash[:notice] = @notice if @notice.present?
  end

  # get the individual error messages
  def get_errors(key, errors)
    return if errors.empty?
    errs = errors.reject(&:blank?).join(", ")
    I18n.t("development_csv.errors.#{key}_error", errors: errs)
  end
end
