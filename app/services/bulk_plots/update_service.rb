# frozen_string_literal: true
module BulkPlots
  class UpdateService < BulkPlots::Base
    def self.call(plot, params: {}, &block)
      service = superclass.call(plot, service: self)
      service.collection.id = plot&.id

      if block_given?
        service.update(params)
        block.call(service, service.numbers, service.errors)
      end

      service
    end

    def update(plot_params)
      plot_params = plot_params.to_h.symbolize_keys
      update_plot_numbers(plot_params)
      update_attributes = bulk_attributes(plot_params)

      return no_numbers_error if numbers.empty?

      update_attributes.map do |attrs|
        update_existing_plots(attrs)
      end.any?
    end

    protected

    BulkUpdatePlotsModel = Class.new(Plot) do
      delegate :model_name, to: :Plot
      attr_accessor :range_from, :range_to, :list

      def persisted?
        true
      end
    end

    def collection_model
      BulkUpdatePlotsModel
    end

    def update_plot_numbers(plot_params)
      collection.assign_attributes(plot_params)
      set_numbers
    end

    def update_existing_plots(attrs)
      updated_plot = Plot.find_by(number: attrs[:number], prefix: params[:prefix])
                       &.update(attrs)

      add_update_error(attrs[:number], attrs[:prefix]) unless updated_plot

      updated_plot
    end

    def add_update_error(number, prefix)
      error_plot = Plot.new(number: number)
      error_plot.errors.add(:number, "not found with a prefix of '#{prefix}'")
      @errors << error_plot
    end
  end
end
