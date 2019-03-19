# frozen_string_literal: true

module BulkPlots
  class ReleaseService < BulkPlots::Base
    # Validate the release request. Check all requested plots do not already have
    # release dates when necessary
    def self.process(phase, mixed_plots, db_column = nil, &block)
      begin
        plot_numbers = split_mixed(mixed_plots.gsub(/\s+/, "")) # chomp spaces
        # only check for popuated plots if a db_column has been specified
        check_populated_plots(phase, plot_numbers, db_column) if db_column
        plot_numbers = physical_plots(phase, plot_numbers)
      rescue => e
        error = e.message
      end

      block.call(plot_numbers, error)
    end

    # Split the entries initially by commas
    def self.split_mixed(mixed_plots)
      raise "Please supply a list of plots" if mixed_plots.empty?
      plots = mixed_plots.split(",")
      # Go through all the plots looking for ranges - ie 10~20.  If
      # one is encpuntered then get it processed into a list of seperate entries
      plots.map! { |plot| plot.include?("~") ? split_range(plot) : plot }
      plots.flatten.natural_sort
    end

    # Check for the supported kinds of ranges and add them to the array
    def self.split_range(range)
      # numeric only ranges - 1-19
      if range.match("[0-9]+~[0-9]+").to_s == range
        (range.split("~").first..range.split("~").second).to_a
      # Alphaumeric ranges - D20~D30, F10~F1
      elsif range.match("[A-Za-z]+[0-9]+~[A-Za-z]+[0-9]+").to_s == range
        AlphaNumericRange.new(range).to_a
      elsif raise "Invalid range #{range}"
      end
    end

    # Given a list of plot numbers, check if any are already populated
    def self.check_populated_plots(phase, plot_numbers, db_column)
      dirty = Plot.where(phase_id: phase)
                  .where(number: plot_numbers)
                  .where("plots.#{db_column} IS NOT NULL").pluck(:number).natural_sort

      return unless dirty.any?
      raise "#{dirty.count > 1 ? 'Plots' : 'Plot'} #{dirty * ','}" \
            " already #{dirty.count > 1 ? 'have' : 'has'} a #{db_column.tr('_', ' ')}"
    end

    # Given a list of possible plot numbers, check which are actual plots.
    # i.e. the range may be 1-20 but there may only be plots at 1,3,6 etc
    def self.physical_plots(phase, plot_numbers)
      plots = Plot.where(phase_id: phase).where(number: plot_numbers).pluck(:number).natural_sort
      unmatched_plots = plot_numbers - plots
      if unmatched_plots.any?
        raise "Plot(s) #{unmatched_plots * ','} do not match plots on this phase. " \
              "Please review and update list or range of plots."
      end
      plots
    end
  end

  # Generate a range of individual alphanumeric values.  supplied range will be
  # in format eg. D1~D20, or F10~F2
  class AlphaNumericRange
    # Analyse and check the range
    def initialize(range)
      @chars = range.scan(/[A-Za-z]/)
      raise raise "Invalid range #{range}" if @chars.first != @chars.second
      @nums = range.scan(/[0-9]+/).map!(&:to_i)
      @increment = @nums.first > @nums.second ? -1 : 1
    end

    # Go thorugh and  generate the entries into an array
    def to_a
      num = @nums.first
      range = []
      loop do
        range << "#{@chars.first}#{num}"
        break if num == @nums.second
        num += @increment
      end
      range
    end
  end
end
