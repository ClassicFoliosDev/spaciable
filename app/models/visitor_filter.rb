# frozen_string_literal: true

class VisitorFilter
  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :developer_id
  attr_accessor :division_id
  attr_accessor :development_id
  attr_accessor :business
  attr_accessor :plots
  attr_accessor :residents
  attr_accessor :stats
  attr_accessor :events

  # Visits calculates visits at the top level, then at all
  # category[n] levels below recursively. This means an event
  # can be specified in terms of a name (the main grouping like
  # 'Contacts') then categories (i.e category1: 'sales') and
  # so on and different counts will be calculated at each
  # level
  class Visits
    attr_accessor :title
    attr_accessor :unique
    attr_accessor :total
    attr_accessor :visits

    # Testing needs to identify rows using a UID constructed
    # from the heirarchical names of a Visit
    attr_accessor :hash if Rails.env.test?

    def initialize(*params)
      @visits = []
      @name, @filter, @categories = params
      @categories ||= []
      @title = @categories&.last || @name
      @hash = VisitorFilter.hash(@name, @categories) if Rails.env.test?
      populate
    end

    def populate
      matches = matching_events
      @unique = uniques(matches).count
      @total = matches.count
      recurse(matches)
    end

    def recurse(matches)
      matches.pluck("properties->'category#{@categories.count + 1}'")
             .uniq.each do |category|
        next if category.nil?

        visits << Visits.new(@name, @filter, @categories.dup << category)
      end
    end

    def matching_events
      filter_by_categories(@filter.events)
    end

    def filter_by_categories(matches)
      return matches if @categories.blank?

      # querying jsob type columns requires a hash with
      # the name value pairs
      filter = @categories.each_with_index.map { |c, i| ["category#{i + 1}".to_sym, c] }.to_h
      matches.where("properties @> ?", filter.to_json)
    end

    def uniques(matches)
      matches.select(:userable_type, :userable_id).distinct.to_a
    end

    def visit(title)
      visits.find { |v| v.title == I18n.t("ahoy.#{title}") }
    end

    # what level am i at
    def depth
      1 + @categories&.count
    end

    # recursively find deepest depth
    def max_depth
      (visits.map(&:max_depth) << depth).max
    end
  end

  def range
    start_date..(end_date + 1.day - 1.second)
  end

  # Initialise the attributes from the passed parameters. The
  # default dates are given defaults but can overwritten
  def initialize(params)
    @end_date = Time.zone.today
    @start_date = @end_date - 1.month
    @stats = {}

    # set the parameters
    params&.each do |attr, value|
      if respond_to?("#{attr}=") && value.present?
        if send(attr).is_a? Date
          send("#{attr}=", Date.parse(value))
        else
          send("#{attr}=", value)
        end
      end
    end

    analyse
  end

  # Get the maximum nested depth
  def max_depth
    (@stats.map { |_, stat| stat.max_depth }).max
  end

  private

  def analyse
    filter_plots
    filter_residents
    calculate_stats
  end

  # Filter the plots according to the parameters
  def filter_plots
    sql = "SELECT plots.* FROM plots INNER JOIN phases ON phases.id = plots.phase_id AND "\
          "phases.deleted_at IS NULL WHERE plots.deleted_at IS NULL AND"
    sql += " phases.business" + (business ? "=#{Phase.businesses[business]}" : " is not null")
    sql += " AND plots.developer_id=#{developer_id}" if developer_id
    sql += " AND plots.division_id=#{division_id}" if division_id
    sql += " AND plots.development_id=#{development_id}" if development_id
    sql += " AND (plots.reservation_release_date IS NOT NULL OR "\
           "      plots.completion_release_date IS NOT NULL)"
    sql += " AND plots.created_at < '#{(end_date + 1.day).strftime("%Y%m%d")}'"
    @plots = ActiveRecord::Base.connection.exec_query(sql)
  end

  # Find the number of unique residents of the plots
  def filter_residents
    residencies = PlotResidency.where(plot_id: @plots.pluck("id"))
                               .pluck(:resident_id).uniq
    @residents = Resident.where(id: residencies)
  end

  # Calculate all the stats
  def calculate_stats
    potential_plots = @plots.pluck("id")
    Ahoy::Event.ahoy_event_names.each do |event, _|
      uniq_event_plts = Ahoy::Event.where(name: I18n.t("ahoy.#{event}"),
                                          time: range).pluck(:plot_id).uniq

      # Get the matches once for each event.  Restrict by the plots meeting the
      # filter criteria
      @events = Ahoy::Event.where(name: I18n.t("ahoy.#{event}"),
                                  time: range,
                                  plot_id: potential_plots & uniq_event_plts)

      # start the process
      @stats[event.to_sym] = Visits.new(I18n.t("ahoy.#{event}"), self)
    end
  end

  # Create a hash from an array of string params
  if Rails.env.test?
    def self.hash(*params)
      "h#{params.flatten.join('').hash}"
    end
  end
end
