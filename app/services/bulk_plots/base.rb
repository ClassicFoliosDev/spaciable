# frozen_string_literal: true

module BulkPlots
  class Base
    def initialize(plot, params:, numbers: nil)
      @base_plot = plot
      @params = params
      @collection = collection_model.new(params)
      @errors = []
      @numbers = numbers || set_numbers
    rescue StandardError => e
      @param_error = e.message
    end

    attr_accessor :collection, :params, :numbers, :errors, :base_plot, :param_error

    BulkPersistPlotsModel = Class.new(Plot) do
      attr_accessor :range_from, :range_to, :list, :validity
    end

    def collection_model
      BulkPersistPlotsModel
    end

    def self.call(plot = Plot.new, params: {}, service: self)
      params = params.to_h.symbolize_keys

      if plot
        service.new(plot, params: build_attrs(plot, params))
      else
        service.new(plot, params: params)
      end
    end

    def self.build_attrs(plot, params)
      base_attrs = plot.attributes.select { |_, value| value.present? }.symbolize_keys
      base_attrs.merge!(params)

      base_attrs[:number] = plot.number if plot.persisted?

      base_attrs
    end

    def errors?
      @errors.any? || @param_error.present?
    end

    def errors
      return @param_error if @param_error.present?
      @errors.group_by { |plot| plot.errors.messages.keys }.map do |_, grouped_plots|
        grouped_error_message(grouped_plots)
      end.join(". ")
    end

    def succeeded
      persisted_numbers = successful_numbers
      digits = persisted_numbers.to_sentence

      I18n.t("plots.bulk.succeeded",
             plot_numbers: digits, count: persisted_numbers.count)
    end

    def bulk_attributes(plot_params = params)
      attributes = plot_params.dup

      bulk_attributes_black_list.each { |attr| attributes.delete(attr) }

      numbers&.map { |number| attributes.merge(number: number) }
    end

    def no_numbers_error
      collection.errors.add(:number, :blank)
      false
    end

    def model_title(collection = [])
      count = collection.count
      Plot.model_name.human.pluralize(count)
    end

    def plots_scope
      base_plot.parent.plots
    end

    private

    def grouped_error_message(plots_with_errors)
      messages = plots_with_errors.map(&:errors).map(&:full_messages).flatten.uniq.to_sentence
      numbers = plots_with_errors.map(&:number).uniq.to_sentence
      title = model_title(plots_with_errors)

      I18n.t("activerecord.errors.messages.bulk_edit_not_save",
             title: title, numbers: numbers, messages: messages)
    end

    def bulk_attributes_black_list
      %i[id created_at updated_at range_from range_to list]
    end

    def set_numbers
      @numbers = BulkPlots::Numbers.new(
        range_from: collection.range_from,
        range_to: collection.range_to,
        list: collection.list
      ).numbers
    end
  end
end
