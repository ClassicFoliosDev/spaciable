# frozen_string_literal: true
module BulkPlots
  class CreateService < BulkPlots::Base
    def self.call(plot, params: {}, &block)
      service = superclass.call(plot, params: params, service: self)

      if block_given?
        service.save
        block.call(service, service.numbers, service.errors)
      end

      service
    end

    def save
      return no_numbers_error if bulk_attributes.empty?

      bulk_attributes.map { |attrs| save_new_plot(attrs) }.any?
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
      new_plot = plots_scope.find_or_initialize_by(number: attrs[:number])
      new_plot.assign_attributes(attrs)

      saved = new_plot.save
      @errors << new_plot unless saved
      saved
    end
  end
end
