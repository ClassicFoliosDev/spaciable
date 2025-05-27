# frozen_string_literal: true

module SortingConcern
  require "natural_sort"
  extend ActiveSupport::Concern

  def sort(resources, default: :updated_at)
    return resources if resources&.empty?

    direction = params[:direction]
    if custom_sort?(resources, params, default, "plots", "number")
      sort_plot_numbers(resources, direction)
    elsif custom_sort?(resources, params, default, "plots", "occupied")
      sort_occupied_plots(resources, direction)
    elsif custom_sort?(resources, params, default, "appliances", "id")
      sort_appliances(resources, direction)
    elsif direction.present? && params[:sort].present?
      sort_resources(resources, params)
    else
      resources&.order(default)
    end
  end

  private

  def custom_sort?(resources, params, default, table_name, sort_on)
    return false unless resources&.table_name == table_name
    return true if params[:sort] == sort_on
    return true if params[:sort].nil? && default.to_s == sort_on

    false
  end

  def sort_resources(resources, params)
    direction = params[:direction] == "desc" ? :desc : :asc

    sort_on_column(resources, params[:sort], params[:sort_on], direction)
  end

  def sort_on_column(resources, column, sort_on, direction)
    return resources.order(column => direction) if sort_on.blank?

    association = resources.first.association(sort_on).klass
    association_order = association.order(column => direction)

    resources
      .joins(sort_on.to_sym)
      .merge(association_order)
  end

  # rubocop:disable Metrics/MethodLength
  def sort_occupied_plots(resources, direction)
    accepted = PlotResidency.accepted(resources).group_by(&:plot_id).keys
    invited =  PlotResidency.invited(resources)
                            .group_by(&:plot_id)
                            .keys.reject { |i| accepted.include? i }

    plot_array = resources.sort
    @numbers = plot_array.map(&:number)
    @ids = plot_array.map(&:id)
    @sorted_numbers = NaturalSort.sort @numbers

    # sort the indexes of the numbers for the invited/accepted plots
    # and move them to the top of the sorted_numbers list
    [invited, accepted].each do |plots|
      sort_by_index(plot_array, plots).each_with_index do |old_index, new_index|
        @sorted_numbers.insert(new_index, @sorted_numbers.delete_at(old_index))
      end
    end

    @sorted_numbers.reverse! if direction == "desc"
    sort_plots
  end
  # rubocop:enable Metrics/MethodLength

  def sort_plot_numbers(resources, direction)
    plot_array = resources.sort

    @numbers = plot_array.map(&:number)
    @ids = plot_array.map(&:id)
    @sorted_numbers = NaturalSort.sort @numbers
    @sorted_numbers.reverse! if direction == "desc"
    sort_plots
  end

  def sort_plots
    sorted_number_string = @sorted_numbers.join(",") + ","
    Plot.where(id: @ids).order("position(','||number::text||',' in '#{sorted_number_string}')")
  end

  def sort_appliances(resources, direction)
    resources.order("appliance_manufacturers.name #{direction}, model_num #{direction}")
  end

  def sort_by_index(plots, occupied)
    indexes = []
    occupied.each do |plot_id|
      indexes << @sorted_numbers.index(plots.detect { |p| p.id == plot_id }.number)
    end
    indexes.sort
  end
end
