# frozen_string_literal: true

module Admin
  class AnalyticsController < ApplicationController
    load_and_authorize_resource :report

    def create
      ReportJob.perform_later(
        current_user,
        params: report_type_params,
        report_params: report_params
      )
    end

    def report_params
      params.require(:report)
            .permit(
              :report_from,
              :report_to,
              :plot_type,
              :developer_id,
              :division_id,
              :development_id
            ).to_a
    end

    def report_type_params
      params.permit(
        :all,
        :developer,
        :billing
      ).to_a
    end
  end
end
