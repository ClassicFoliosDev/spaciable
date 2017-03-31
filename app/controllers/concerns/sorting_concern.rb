# frozen_string_literal: true
module SortingConcern
  extend ActiveSupport::Concern

  def sort(resources, default: :updated_at)
    return resources if resources&.empty?

    if params[:direction].present? && params[:sort].present?
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
end
