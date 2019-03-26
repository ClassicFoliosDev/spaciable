# frozen_string_literal: true

module BulkPlots
  class ReleaseService < BulkPlots::Base
    attr_accessor :successfull_numbers
    attr_reader :release_errors

    def self.call(params: {}, &block)
      service = superclass.call(nil, params: { list: params[:list] }, service: self)

      if block_given?
        service.process(params)
        block.call(service, service.successfull_numbers, service.release_errors)
      end

      service
    end

    # Validate the release request. Check all requested plots do not already have
    # release dates when necessary
    def process(params)
      phase = params[:phase_id]
      # only check for popuated plots if a db_column has been specified
      check_populated_plots(phase, @numbers, params[:release_type])
      @successfull_numbers = physical_plots(phase, @numbers)
    rescue => e
      @release_errors = e.message
    end

    # Given a list of plot numbers, check if any are already populated
    def check_populated_plots(phase, plot_numbers, db_column)
      dirty = Plot.where(phase_id: phase)
                  .where(number: plot_numbers)
                  .where("plots.#{db_column} IS NOT NULL").pluck(:number).natural_sort

      return unless dirty.any?
      raise "#{dirty.count > 1 ? 'Plots' : 'Plot'} #{dirty * ','}" \
            " already #{dirty.count > 1 ? 'have' : 'has'} a #{db_column.tr('_', ' ')}"
    end

    # Given a list of possible plot numbers, check which are actual plots.
    # i.e. the range may be 1-20 but there may only be plots at 1,3,6 etc
    def physical_plots(phase, plot_numbers)
      plots = Plot.where(phase_id: phase).where(number: plot_numbers).pluck(:number).natural_sort
      unmatched_plots = plot_numbers - plots
      if unmatched_plots.any?
        raise "Plot(s) #{unmatched_plots * ','} do not match plots on this phase. " \
              "Please review and update list or range of plots."
      end
      plots
    end
  end
end
