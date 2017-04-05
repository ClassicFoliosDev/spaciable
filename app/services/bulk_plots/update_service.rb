# frozen_string_literal: true
module BulkPlots
  class UpdateService < BulkPlots::Base
    def self.call(plot, params: {}, &block)
      service = superclass.call(plot, service: self)
      service.collection.id = plot&.id

      if block_given?
        service.update(params)
        block.call(service, service.successful_numbers, service.errors)
      end

      service
    end

    def update(plot_params)
      self.params = plot_params.to_h.symbolize_keys

      if any_bulk_attrs?
        update_plot_numbers
        return no_numbers_error if numbers.empty?

        bulk_attributes(params).map do |attrs|
          update_existing_plots(attrs)
        end.any?
      else
        bulk_attr_keys.each { |attr| params.delete(attr) }
        base_plot.update(params)
      end
    end

    def successful_numbers
      numbers = sanitize

      return Array(base_plot.number) unless any_bulk_attrs?

      @errors.each do |error|
        numbers.delete(error.number) if numbers.include?(error.number)
      end

      numbers
    end

    protected

    def sanitize
      new_numbers = []
      numbers.each do |number|
        new_numbers.push(number.to_s) unless new_numbers.include?(number.to_s)
      end

      new_numbers
    end

    def any_bulk_attrs?
      params.values_at(*bulk_attr_keys).any?(&:present?)
    end

    def bulk_attr_keys
      [:range_from, :range_to, :list]
    end

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

    def update_plot_numbers
      collection.assign_attributes(params)
      set_numbers
    end

    def update_existing_plots(attrs)
      updated_plots = plots_scope.where(number: attrs[:number].to_s)
                       &.update(attrs)

      add_update_error(attrs[:number]) if updated_plots.empty?

      updated_plots
    end

    def add_update_error(number)
      error_plot = Plot.new(number: number)
      error_plot.errors.add(:base, :missing)
      @errors << error_plot
    end
  end
end
