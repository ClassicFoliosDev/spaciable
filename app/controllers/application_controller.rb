# frozen_string_literal: true
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :redirect_homeowners, if: -> { current_user }
  check_authorization unless: :devise_controller?

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    referrer = request.referer
    url = if !referrer.blank? && referrer != request.url
            referrer
          else
            root_url
          end

    redirect_to url
  end

  private

  def redirect_homeowners
    redirect_to(homeowner_dashboard_path) && return if current_user.owner?
  end
end
