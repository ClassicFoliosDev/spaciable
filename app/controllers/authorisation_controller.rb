
# frozen_string_literal: true

class AuthorisationController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :redirect_residents
  skip_authorization_check

  def oauth_callback
    if params[:error]
      redirect_error
    else
      current_resident ? auth_resident : auth_admin
    end
  end

  # rubocop:disable Metrics/AbcSize

  # Authorise a resident and add a token to their landord account
  def auth_resident
    if !session[:landlordlistings]
      redirect _to root_url
    elsif session[:landlordlistings]&.matches? params[:state]
      error = current_resident.authorise params[:code]
      flash[:alert] = error if error
      redirect_to session[:landlordlistings].redirect_url
    else
      redirect_to root_url
    end
  end

  def auth_admin
    if !session[:adminlistings]
      redirect_to root_url
    elsif session[:adminlistings]&.matches? params[:state]
      error = current_user.authorise params[:code]
      flash[:alert] = error if error
      redirect_to session[:adminlistings].redirect_url
    else
      redirect_to root_url
    end
  end

  # rubocop:enable Metrics/AbcSize

  private

  def redirect_error
    flash[:alert] = params[:error_description]
    if current_resident && session[:landlordlistings]
      redirect_to session[:landlordlistings].redirect_url
    elsif current_user && session[:adminlistings]
      redirect_to session[:adminlistings].redirect_url
    else
      redirect_to root_url
    end
  end
end
