# frozen_string_literal: true

class HomeController < ApplicationController
  layout "home"
  skip_before_action :authenticate_user!
  skip_authorization_check
  skip_before_action :redirect_residents, only: %i[data_policy cookies_policy ts_and_cs_admin
                                                   ts_and_cs_homeowner feedback]

  def show
    redirect_to(homeowner_dashboard_path) && return if current_resident
    redirect_to(admin_dashboard_path) && return if current_user
  end

  def ts_and_cs_admin
    render "legal/ts_and_cs_admin"
  end

  def ts_and_cs_homeowner
    render "legal/ts_and_cs_homeowner"
  end

  def data_policy
    render "legal/data_policy"
  end

  def cookies_policy
    render "legal/cookies_policy"
  end

  def feedback
    FeedbackNotificationJob.perform_later(params[:comments], params[:option], params[:email])
    render json: ""
  end
end
