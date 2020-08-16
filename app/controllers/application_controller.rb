# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :redirect_residents, if: -> { current_resident }
  before_action :authenticate_user!
  before_action :initialise_callback
  before_action :set_current_user

  check_authorization unless: :devise_controller?

  protect_from_forgery with: :exception, prepend: true

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    flash[:alert] = t("controller.resource_not_found")

    redirect_to previous_url
  end

  rescue_from Aws::S3::Errors::Forbidden do |_exception|
    flash[:alert] = t("controller.no_s3_access") if Rails.env.production?
    redirect_to previous_url
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to previous_url
  end

  private

  def previous_url
    referrer = request.referer

    if referrer.present? && referrer != request.url
      referrer
    else
      root_url
    end
  end

  def redirect_residents
    redirect_to(dashboard_path) && return if current_resident
  end

  def after_sign_out_path_for(resource_or_scope)
    return build_sign_in_path(@plot) if @plot

    new_session_path(resource_or_scope)
  end

  def build_sign_in_path(plot)
    path = root_url

    path << plot.developer.to_s.parameterize_amp
    path << "/#{plot.division.to_s.parameterize_amp}" if plot.division
    path << "/#{plot.development.to_s.parameterize_amp}"
    path << "/sign_in"
    byebug
  end

  def initialise_callback
    PlanetRent.initialize URI.parse(request.url).host
  end

  # Set the current user in a thread safe store so as the models can access it
  def set_current_user
    RequestStore.store[:current_user] = current_user
  end
end
