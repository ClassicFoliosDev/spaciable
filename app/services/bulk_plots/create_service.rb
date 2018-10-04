# frozen_string_literal: true

module BulkPlots
  class CreateService < BulkPlots::Base
    def self.call(plot, params: {}, &block)
      service = superclass.call(plot, params: params, service: self)

      if block_given?
        service.save
        block.call(service, service.successful_numbers, service.errors)
      end

      service
    end

    def save
      return no_numbers_error if bulk_attributes.empty?

      bulk_attributes.map { |attrs| save_new_plot(attrs) }.any?
    end

    def successful_numbers
      @successful_numbers ||= []
    end

    protected

    BulkCreatePlotsModel = Class.new(Plot) do
      delegate :model_name, to: :Plot
      attr_accessor :range_from, :range_to, :list
    end

    def collection_model
      BulkCreatePlotsModel
    end

    def save_new_plot(attrs)
      new_plot = plots_scope.build(attrs)
      new_plot.progress = :soon if new_plot.progress.nil?
      new_plot.house_number = new_plot.number if attrs[:copy_plot_numbers]

      if (saved = new_plot.save)
        successful_numbers << new_plot.number
      else
        @errors << new_plot
      end

      saved
    end
  end
end
