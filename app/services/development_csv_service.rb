# frozen_string_literal: true

# rubocop:disable ModuleLength
module DevelopmentCsvService
  module_function

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
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def import(file, development)
    csv = CSV.open(file.path, headers: true).read
    return unless headers_check?(csv.headers)

    csv.each do |row|
      catch(:next_row) do
        # find the phase from development
        phase_name = datum(row, :phase)
        phase = Phase.find_by(development_id: development.id, name: phase_name)
        @parsed[phase_name] ||= {} # Create the hash for this phase_name name
        @parsed[phase_name][:success] ||= [] # initialise array for phase successes

        # Check the phase
        next unless phase_check?(phase_name, phase)

        # Get the plot
        plot = Plot.find_by(phase_id: phase.id, number: datum(row, :number))

        # go through the checks
        %i[plot duplicate unit completion progress uprn].each do |stage|
          throw(:next_row, true) unless send("#{stage}_check?", phase_name, row, plot, development)
        end

        # store the successful plot number for notifying
        @parsed[phase_name][:success] << plot.number if plot.save!
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # store an error if the phase is unknown
  def phase_check?(phase_name, phase)
    @parsed[phase_name][:phase] ||= []
    @parsed[phase_name][:phase] << phase_name unless phase
    unless phase && (!phase.free? || RequestStore.store[:current_user].cf_admin?)
      @parsed[phase_name][:free_phase] ||= []
      @parsed[phase_name][:free_phase] << phase_name
    end
    phase.present? && (!phase.free? || RequestStore.store[:current_user].cf_admin?)
  end

  # store an error if the plot is unknown
  def plot_check?(phase_name, row, plot, _)
    @parsed[phase_name][:plot] ||= []
    @parsed[phase_name][:plot] << datum(row, :number) unless plot

    if plot.present?
      set(plot, row, :prefix)
      set(plot, row, :house_number)
      set(plot, row, :building_name)
      set(plot, row, :road_name)
      set(plot, row, :postcode)
      set(plot, row, :reservation_order_number)
      set(plot, row, :completion_order_number)
    end

    plot.present?
  end

  # store an error if the plot number is duplicated in the CSV for that phase
  # if a previous instance of the plot was successfully saved then those values will remain
  # if a previous instance of the plot was unsuccessful then the duplicate plot attributes will
  # not be updated, even if they are valid
  def duplicate_check?(phase_name, row, _, _)
    @parsed[phase_name][:duplicate] ||= []
    if @parsed[phase_name][:plot].include?(datum(row, :number)) ||
       @parsed[phase_name][:success].include?(datum(row, :number))
      @parsed[phase_name][:duplicate] << datum(row, :number)
      return false
    else
      return true
    end
  end

  # check the unit type exists and store an error if it does not
  def unit_check?(phase_name, row, plot, development)
    @parsed[phase_name][:unit] ||= []
    passed = datum(row, :unit_type).blank?

    unless passed
      unit_id = UnitType.find_by(development_id: development.id, name: datum(row, :unit_type))
      passed = unit_id.present?
      plot.unit_type_id = unit_id.id if passed
    end

    @parsed[phase_name][:unit] << datum(row, :unit_type) unless passed
    passed
  end

  # check the uprn is in the correct format and store an error if it is not
  def uprn_check?(phase_name, row, plot, _)
    @parsed[phase_name][:uprn] ||= []
    passed = true

    if datum(row, :uprn).present?
      passed = datum(row, :uprn).length <= 12 && (datum(row, :uprn) =~ /\A\d*\z/ ? true : false)
      plot.uprn = datum(row, :uprn) if passed
    end

    @parsed[phase_name][:uprn] << datum(row, :uprn) unless passed
    passed
  end

  # check the legal completion date is in date format and within the specified range
  # and store an error if it is not
  def completion_check?(phase_name, row, plot, _)
    @parsed[phase_name][:completion] ||= []
    passed = datum(row, :completion_date).blank?

    # check the legal completion date is in date format and within the specified range
    # and store an error if it is not
    unless passed
      begin
        date = Date.parse(datum(row, :completion_date))
        passed = date.between?((Time.zone.today - 6.months), (Time.zone.today + 1.year))
        plot.completion_date = date if passed
      rescue
        passed = false
      end
    end

    @parsed[phase_name][:completion] << datum(row, :completion_date) unless passed
    passed
  end

  # check the build progress is valid and store an error if it is not
  def progress_check?(phase_name, row, plot, _)
    @parsed[phase_name][:progress] ||= []
    passed = true

    if datum(row, :build_step).present?
      build_step = Phase.find_by(name: phase_name)
                        .build_steps
                        .find_by(title: datum(row, :build_step))
      passed = build_step.present?
      plot.build_step = build_step if passed
      @parsed[phase_name][:progress] << datum(row, :build_step) unless passed
    end

    passed
  end

  def headers_check?(headers)
    @parsed["H"] ||= {}
    @parsed["H"][:invalid_column] ||= []
    legal_columns = DevelopmentCsv.filtered_column_names
    headers.each { |h| @parsed["H"][:invalid_column] << h unless legal_columns.include?(h) }
    @parsed["H"][:invalid_column].count.zero?
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
  # rubocop:disable LineLength
  def build_messages
    messages = {}
    @parsed.each do |phase_name, stages|
      stages.each do |stage, errs|
        next if errs.empty?
        messages[stage] ||= []
        messages[stage] <<
          "#{%i[phase invalid_column].include?(stage) ? nil : phase_name + ':'} #{errs.reject(&:blank?).uniq.join(', ')}"
      end
    end

    yield messages.except(:success).map { |k, v| get_errors(k, v) }.join(" "),
          messages.slice(:success).map { |_, v| get_successes(v) }.join(" ")
  end
  # rubocop:enable LineLength

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

  def datum(row, column_name)
    row[I18n.t("development_csv.#{column_name}")]
  end

  def set(plot, row, column_name)
    plot.send("#{column_name}=", datum(row, column_name)) if datum(row, column_name).present?
  end
end
# rubocop:enable ModuleLength
