# frozen_string_literal: true

module Admin
  class AnalyticsController < ApplicationController
    load_and_authorize_resource :report

    def new
      @report = Report.new
    end

    def create
      @report = Report.new(report_params)

      if @report.valid?
        send_file build_csv, disposition: :attachment
      else
        render :new
      end
    end

    private

    def build_csv
      return Csv::DeveloperCsvService.call(@report) if params[:developer].present?
      Csv::DevelopmentCsvService.call(@report)
    end

    def report_params
      params.require(:report)
            .permit(
              :report_from,
              :report_to,
              :developer_id,
              :division_id,
              :development_id
            )
    end
  end
end
