# frozen_string_literal: true
class ApplicationController < ActionController::Base
  before_action :redirect_residents, if: -> { current_resident }
  before_action :authenticate_user!

  check_authorization unless: :devise_controller?

  protect_from_forgery with: :exception, prepend: true

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    flash[:alert] = t("controller.resource_not_found")

    redirect_to previous_url
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message

    redirect_to previous_url
  end

  private

  def previous_url
    referrer = request.referer

    if !referrer.blank? && referrer != request.url
      referrer
    else
      root_url
    end
  end

  def redirect_residents
    redirect_to(homeowner_dashboard_path) && return
  end

  def after_sign_out_path_for(resource_or_scope)
    new_session_path(resource_or_scope)
  end
end
