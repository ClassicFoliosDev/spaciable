# frozen_string_literal: true
module SortingConcern
  extend ActiveSupport::Concern

  def sort(resources, default: :updated_at)
    if params[:direction].present? && params[:sort].present?
      direction = params[:direction] == "desc" ? :desc : :asc
      resources.order(params[:sort] => direction)
    else
      resources.order(default)
    end
  end
end
