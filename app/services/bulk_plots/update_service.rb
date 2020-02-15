# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
module BulkPlots
  class UpdateService < BulkPlots::Base
    def self.call(plot, params: {}, &block)
      service = superclass.call(plot, service: self)
      service.collection.id = plot&.id

      if block_given?
        service.update(params) unless service.errors?
        block.call(service, service.successful_numbers, service.errors)
      end

      service
    end

    def update(plot_params)
      self.params = plot_params.to_h.symbolize_keys
      params[:progress] = base_plot.progress if plot_params[:progress]&.empty?

      bulk_or_single_update

      # Dummy plot is for bulk update and does not need validation
      @errors << base_plot if base_plot.invalid? && (base_plot.number != Plot::DUMMY_PLOT_NAME)
    rescue StandardError => e
      @param_error = e.message
    end

    def bulk_or_single_update
      if any_bulk_attrs?
        bulk_update
      else
        single_update
      end
    end

    def single_update
      if params.keys.include? :unit_type_id_check
        add_error I18n.t("activerecord.errors.messages.bulk_edit_no_plots")
        return
      end
      bulk_attr_keys.each { |attr| params.delete(attr) }
      # Wrap the plot updates in a transaction to ensure data integrity
      ActiveRecord::Base.transaction do
        delete_templated_rooms(base_plot) if params[:ut_update_option] == UnitType::RESET.to_s
        params.delete(:ut_update_option)
        base_plot.update(params)
      end
    end

    # Plots have templated rooms to supplement/replace those dictated by their
    # associated unit_types.  When a plot is assigned a new unit type and the user
    # has chosen to replace all 'local' room updates for the plot, then all the
    # templated rooms need to be removed, including those that have been deleted.
    def delete_templated_rooms(plot)
      templated_rooms = Room.where(plot_id: plot.id).with_deleted
      templated_rooms.each(&:really_destroy!)
    end

    def bulk_update
      update_plot_numbers
      return no_numbers_error if numbers.empty?

      bulk_attributes(params)&.map do |attrs|
        update_existing_plot(attrs)
      end.any?
    end

    def successful_numbers
      numbers = sanitize

      return Array(base_plot&.id) unless any_bulk_attrs?

      @errors.each do |error|
        numbers.delete(error.number) if numbers.include?(error.number)
      end

      return [] if @attribute_params.blank? || @attribute_params.empty?

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

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def update_existing_plot(attrs)
      updates = attribute_params(attrs)
      updated_plot = plots_scope.where(number: attrs[:number].to_s)
                       &.update(updates)

      # If there is an updated plot and the unit type is being updated
      # and the user has selected to reset the rooms to just those for the
      # new unit type
      if updated_plot.present? &&
         params[:ut_update_option] == UnitType::RESET.to_s &&
         updates.keys.include?(:unit_type_id)
        # delete all templated rooms for the plot
        delete_templated_rooms(updated_plot[0])
      end

      if @attribute_params[:copy_plot_numbers] == true
        plots_scope.where(number: attrs[:number].to_s).map do |plot|
          next if plot.number == Plot::DUMMY_PLOT_NAME
          plot.update_attributes(house_number: plot.number)
        end
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

      add_update_error(attrs[:number]) if updated_plot.empty?

      updated_plot
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

      validate_params

      @attribute_params
    end

    def validate_params
      validate_mandatory_param(:unit_type_id, UnitType.model_name.human)
      validate_mandatory_param(:validity,
                               I18n.t("activerecord.attributes.plot.validity"))
      validate_mandatory_param(:extended_access,
                               I18n.t("activerecord.attributes.plot.extended_access"))

      return if @attribute_params.any? || @errors.any?

      plots_scope.where(number: update_plot_numbers).each do |plot|
        plot.errors[:base] << I18n.t("activerecord.errors.messages.bulk_edit_no_fields")
        @errors << plot
      end
    end

    def validate_mandatory_param(param_sym, param_name)
      return unless @attribute_params.include? param_sym
      return if @attribute_params[param_sym].present?

      plots_scope.where(number: update_plot_numbers).each do |plot|
        plot.errors[:base] << I18n.t("activerecord.errors.messages.bulk_edit_field_blank",
                                     field_name: param_name)
        @errors << plot
      end

      @attribute_params.delete(param_sym)
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
