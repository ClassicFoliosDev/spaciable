# frozen_string_literal: true

class HomeController < ApplicationController
  layout "home"
  skip_before_action :authenticate_user!
  skip_authorization_check
  skip_before_action :redirect_residents, only: %i[data_policy ts_and_cs ts_and_cs2 feedback]

  def show
    redirect_to(homeowner_dashboard_path) && return if current_resident
    redirect_to(admin_dashboard_path) && return if current_user
  end

  def ts_and_cs
    render "legal/ts_and_cs"
  end

  def ts_and_cs2
    render "legal/ts_and_cs2"
  end

  def data_policy
    render "legal/data_policy"
  end

  def feedback
    FeedbackNotificationJob.perform_later(params[:comments], params[:option], params[:email])
    render json: ""
  end
end
