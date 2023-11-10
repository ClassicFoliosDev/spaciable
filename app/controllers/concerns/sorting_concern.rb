# frozen_string_literal: true

module SortingConcern
  require "natural_sort"
  extend ActiveSupport::Concern

  def sort(resources, default: :updated_at)
    return resources if resources&.empty?

    direction = params[:direction]
    if custom_sort?(resources, params, default, "plots", "number")
      sort_plot_numbers(resources, direction)
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
end
