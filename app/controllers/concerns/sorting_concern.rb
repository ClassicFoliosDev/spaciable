# frozen_string_literal: true
module SortingConcern
  extend ActiveSupport::Concern

  def sort(resources, default: :updated_at)
    return resources if resources&.empty?

    if default == :number && resources.table_name == "plots"
      sort_plot_numbers(resources, params[:direction])
    elsif params[:direction].present? && params[:sort].present?
      direction = params[:direction] == "desc" ? :desc : :asc

      sort_on_column(resources, params[:sort], params[:sort_on], direction)
    elsif resources
      resources&.order(default)
    end
  end

  private

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

    ids = plot_array.map(&:id)
    ids = ids.reverse if direction == "desc"

    Plot.where(id: ids).order("position(id::text in '#{ids.join(',')}')")
  end
end
