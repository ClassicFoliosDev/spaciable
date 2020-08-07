# frozen_string_literal: true

# rubocop:disable ModuleLength
module DevelopmentCsvService
  module_function

  PHASE = 0
  PLOT = 1
  UNIT = 2
  UPRN = 3
  PREFIX = 4
  HOUSE_NUMBER = 5
  BUILDING_NAME = 6
  ROAD_NAME = 7
  POSTCODE = 8
  LEGAL_COMP_DATE = 9
  PROGRESS = 10
  ORDER_RES = 11
  ORDER_COMP = 12

  require "date"

  def call(file, development, flash)
    return notify_type_error(flash) unless correct_content_type(file) # check the file type
    @parsed = {}
    @success_plots = []
    import(file, development)
    notify(flash)
  end

  # check the file type is valid - currently only the template csv file type is valid
  def correct_content_type(file)
    acceptable_types = ["text/csv", "text/x-csv", "application/vnd.ms-excel", "application/csv",
                        "application/x-csv", "text/comma-separated-values",
                        "text/x-comma-separated-values"]
    acceptable_types.include? file.content_type.chomp
  end

  # the loop will exit once an error is encountered, so will not check any further fields,
  # meaning only the first found error for each plot will be stored for the alert
  def import(file, development)
    CSV.foreach(file.path, headers: true) do |row|
      catch(:next_row) do
        # find the phase from development
        phase_name = row[PHASE]
        phase = Phase.find_by(development_id: development.id, name: phase_name)
        @parsed[phase_name] ||= {} # Create the hash for this phase_name name
        @parsed[phase_name][:success] ||= [] # initialise array for phase successes

        # Check the phase
        next unless phase_check?(phase_name, phase)

        # Get the plot
        plot = Plot.find_by(phase_id: phase.id, number: row[PLOT])

        # go through the checks
        %i[plot duplicate unit completion progress uprn].each do |stage|
          throw(:next_row, true) unless send("#{stage}_check?", phase_name, row, plot, development)
        end

        # store the successful plot number for notifying
        @parsed[phase_name][:success] << plot.number if plot.save!
      end
    end
  end

  # store an error if the phase is unknown
  def phase_check?(phase_name, phase)
    @parsed[phase_name][:phase] ||= []
    @parsed[phase_name][:phase] << phase_name unless phase
    phase.present?
  end

  # store an error if the plot is unknown
  # rubocop:disable all
  def plot_check?(phase_name, row, plot, _)
    @parsed[phase_name][:plot] ||= []
    @parsed[phase_name][:plot] << (row[PLOT]) unless plot

    if plot.present?
      plot.prefix = row[PREFIX] if row[PREFIX].present?
      plot.house_number = row[HOUSE_NUMBER] if row[HOUSE_NUMBER].present?
      plot.building_name = row[BUILDING_NAME] if row[BUILDING_NAME].present?
      plot.road_name = row[ROAD_NAME] if row[ROAD_NAME].present?
      plot.postcode = row[POSTCODE] if row[POSTCODE].present?
      plot.reservation_order_number = row[ORDER_RES] if row[ORDER_RES].present?
      plot.completion_order_number = row[ORDER_COMP] if row[ORDER_COMP].present?
    end

    plot.present?
  end
  # rubocop:enable all

  # store an error if the plot number is duplicated in the CSV for that phase
  # if a previous instance of the plot was successfully saved then those values will remain
  # if a previous instance of the plot was unsuccessful then the duplicate plot attributes will
  # not be updated, even if they are valid
  def duplicate_check?(phase_name, row, _, _)
    @parsed[phase_name][:duplicate] ||= []
    if @parsed[phase_name][:plot].include?(row[PLOT]) ||
       @parsed[phase_name][:success].include?(row[PLOT])
      @parsed[phase_name][:duplicate] << (row[PLOT])
      return false
    else
      return true
    end
  end

  # check the unit type exists and store an error if it does not
  def unit_check?(phase_name, row, plot, development)
    @parsed[phase_name][:unit] ||= []
    passed = row[UNIT].blank?

    unless passed
      unit_id = UnitType.find_by(development_id: development.id, name: row[UNIT])
      passed = unit_id.present?
      plot.unit_type_id = unit_id.id if passed
    end

    @parsed[phase_name][:unit] << row[UNIT] unless passed
    passed
  end

  # check the uprn is in the correct format and store an error if it is not
  def uprn_check?(phase_name, row, plot, _)
    @parsed[phase_name][:uprn] ||= []
    passed = true

    if row[UPRN].present?
      passed = row[UPRN].length <= 12
      passed = row[UPRN] =~ /\A\d*\z/ ? true : false
      plot.uprn = row[UPRN] if passed
    end

    @parsed[phase_name][:uprn] << row[UPRN] unless passed
    passed
  end

  # check the legal completion date is in date format and within the specified range
  # and store an error if it is not
  def completion_check?(phase_name, row, plot, _)
    @parsed[phase_name][:completion] ||= []
    passed = row[LEGAL_COMP_DATE].blank?

    # check the legal completion date is in date format and within the specified range
    # and store an error if it is not
    unless passed
      begin
        date = Date.parse(row[LEGAL_COMP_DATE])
        passed = date.between?((Time.zone.today - 6.months), (Time.zone.today + 1.year))
        plot.completion_date = date if passed
      rescue
        passed = false
      end
    end

    @parsed[phase_name][:completion] << row[PLOT] unless passed
    passed
  end

  # check the build progress is valid and store an error if it is not
  def progress_check?(phase_name, row, plot, _)
    @parsed[phase_name][:progress] ||= []
    passed = true

    if row[PROGRESS].present?
      passed = Plot.progresses.include?(row[PROGRESS])
      plot.progress = row[PROGRESS] if passed
      @parsed[phase_name][:progress] << row[PROGRESS] unless passed
    end

    passed
  end

  # error message for incorrect file type
  def notify_type_error(flash)
    flash[:alert] = I18n.t("development_csv.errors.file_type")
  end

  # build the information messages
  # rubocop:disable all
  def notify(flash)
    build_messages do |alert, notice|
      if alert.present?
        alert = I18n.t("development_csv.errors.overview",
                       errors: alert).html_safe
      end
      notify_flash(flash, alert, notice)
    end
  end
  # rubocop:enable all

  # The @parsed hash uses phase names as a key. Each phase name hash is another hash of
  # parsing 'stages'. So for a phase called "Park Lane", there will be hashes for all
  # "Park Lane" lines stages that fail to pass, plus information for successful passes.
  # Each 'stage' hash holds an array of information for that stage i.e.
  #
  # @parsed["Park Lane"][:plots][1,2,3,4] # Park Lane does not have plots 1,2,3,4
  # @parsed["Wick Lane"][:plots][4,5,6] # Wick Lane does not have plots 4,5,6
  # @parsed["Park Life"][:phase]['Park Life'] # Park Life phase does not exist
  # @parsed["Park Life"][:unit]['unit error'] # Park Life phase does not have a unit
  # type 'unit error'
  # @parsed["Park Lane"][:success][5,6,7] # Park Lane plots 5,6,7 updated successfully
  # @parsed["Love Lane"][:success][6,7,8] # Love Lane plots 6,7,8 updated successfully
  #
  # The build_messages function goes through each phase and associated stages,
  # then within each stage it concatenates the phase name together with the (comma separated)
  # associated information. This line of information is then added to a hash of stages,
  # each of which has an array i.e.
  #
  # messages[:plots]["Park Lane: 1,2,3,4", "Wick Lane: 4,5,6"]
  # messages[:phase]["Park Life]
  # messages[:unit]["Park Lane: unit error"]
  # messages[:success]["Park Lane: 5,6,7", "Love Lane: 6,7,8"]
  #
  # Finally, all the error and success messages for each stage are joined together and
  # inserted into their configured text translations and returned as single error and
  # success messages
  def build_messages
    messages = {}
    @parsed.each do |phase_name, stages|
      stages.each do |stage, errs|
        next if errs.empty?
        messages[stage] ||= []
        messages[stage] <<
          "#{stage == :phase ? nil : phase_name + ':'} #{errs.reject(&:blank?).uniq.join(', ')}"
      end
    end

    yield messages.except(:success).map { |k, v| get_errors(k, v) }.join(" "),
          messages.slice(:success).map { |_, v| get_successes(v) }.join(" ")
  end

  def notify_flash(flash, alert, notice)
    flash[:alert] = unless alert.present? || notice.present?
                      I18n.t("development_csv.errors.no_plots")
                    end
    flash[:alert] = alert if alert.present?
    flash[:notice] = notice if notice.present?
  end

  # get the individual error messages
  def get_errors(key, errors)
    I18n.t("development_csv.errors.#{key}_error", errors: errors.join(" "))
  end

  # get the successes
  def get_successes(successes)
    I18n.t("development_csv.errors.success", plots: successes.join(" "))
  end
end
# rubocop:enable ModuleLength
