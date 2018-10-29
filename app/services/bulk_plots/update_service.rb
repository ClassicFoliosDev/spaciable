# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
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
      params[:progress] = base_plot.progress if plot_params[:progress]&.empty?

      bulk_update

      # Dummy plot is for bulk update and does not need validation
      @errors << base_plot if base_plot.invalid? && (base_plot.number != Plot::DUMMY_PLOT_NAME)
    end

    def bulk_update
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

      return Array(base_plot&.id) unless any_bulk_attrs?

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
      %i[range_from range_to list]
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
      collection.assign_attributes(plot_select_params)
      set_numbers
    end

    def update_existing_plots(attrs)
      updated_plots = plots_scope.where(number: attrs[:number].to_s)
                       &.update(attribute_params(attrs))

      if @attribute_params[:copy_plot_numbers] == true
        plots_scope.where(number: attrs[:number].to_s).map do |plot|
          next if plot.number == Plot::DUMMY_PLOT_NAME
          plot.update_attributes(house_number: plot.number)
        end
      end

      add_update_error(attrs[:number]) if updated_plots.empty?

      updated_plots
    end

    def plot_select_params
      plot_select_params = {}
      plot_select_params[:range_from] = params[:range_from]
      plot_select_params[:range_to] = params[:range_to]
      plot_select_params[:list] = params[:list]

      plot_select_params
    end

    def attribute_params(attrs)
      @attribute_params = attrs
      return @attribute_params unless params.keys.include? :unit_type_id_check

      @attribute_params = {}
      params.keys.each do |key|
        bulk_attribute(key)
      end

      if @attribute_params.empty?
        add_error I18n.t("activerecord.errors.messages.bulk_edit_no_fields")
      end

      @attribute_params
    end

    def bulk_attribute(key)
      @attribute_params[key] = true if key == :copy_plot_numbers && params[key].to_i.positive?

      # For bulk update, only set values if the associated checkbox is set
      return unless key.to_s.end_with?("_check")
      return unless params[key].to_i.positive?

      key_to_keep = key.to_s.chomp("_check").to_sym
      @attribute_params[key_to_keep] = params[key_to_keep]
    end

    def add_update_error(number)
      return if number == Plot::DUMMY_PLOT_NAME

      error_plot = Plot.new(number: number)
      error_plot.errors.add(:base, :missing)
      @errors << error_plot
    end

    def add_error(message)
      base_plot.phase.errors[:base] << message
      @errors << base_plot.phase
    end
  end
end
# rubocop:enable Metrics/ClassLength
