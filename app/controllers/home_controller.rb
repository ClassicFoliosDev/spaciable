# frozen_string_literal: true
class HomeController < ApplicationController
  layout "home"
  skip_before_action :authenticate_user!
  skip_authorization_check
  skip_before_action :redirect_residents, only: :data_policy

  def show
    redirect_to(homeowner_dashboard_path) && return if current_resident
    redirect_to(admin_dashboard_path) && return if current_user
  end

  def ts_and_cs
    render "homeowners/dashboard/ts_and_cs"
  end

  def data_policy
    render "homeowners/dashboard/data_policy"
  end
end
