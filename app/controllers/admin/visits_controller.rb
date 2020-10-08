# frozen_string_literal: true

module Admin
  class VisitsController < ApplicationController
    load_and_authorize_resource :report

    def show
      @visits = VisitorFilter.new(filter_params["visits"])
    end

    def create
      VisitsJob.perform_later(current_user,
                              filter_params["visits"].to_h)
    end

    def filter_params
      params.permit(visits: %i[ developer_id division_id
                                development_id start_date
                                end_date business ])
    end
  end
end
