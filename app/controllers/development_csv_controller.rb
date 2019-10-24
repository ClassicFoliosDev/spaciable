# frozen_string_literal: true

class DevelopmentCsvController < ApplicationController
  load_and_authorize_resource :development

  def index
    redirect_to root_url unless current_user.cf_admin? # only accessible by cf admins
    @plot = Plot.new
  end

  def create
    if params[:plot].present?
      DevelopmentCsvService.call(params[:plot][:file], @development, flash)
      alert = nil
    else
      alert = I18n.t("development_csv.errors.no_file") # alert if no file is uploaded
    end
    redirect_to development_development_csv_index_path(@development), alert: alert
  end

  def download_template
    template = "app/assets/files/development_csv_template.csv"
    send_file(template, disposition: :attachment)
  end
end
