# frozen_string_literal: true

module Homeowners
  class AnalyticsEventsController < Homeowners::BaseController
    def create
      record_event(params[:activity],
                   category1: category(:category1),
                   category2: category(:category2))

      render json: { message: :created }, status: :created
    end

    private

    def category(cat)
      return nil if params[cat].blank?

      I18n.t("ahoy.calendar.#{params[:category1]}")
    end
  end
end
