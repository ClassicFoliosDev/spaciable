# frozen_string_literal: true

module Residents
  class SessionsController < Devise::SessionsController
    layout "login"

    skip_before_action :redirect_residents

    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    def new
      self.resource = resource_class.new(sign_in_params)
      development = DevelopmentFinderService.call(params)
      @brand = development&.brand_any
      clean_up_passwords(resource)

      yield resource if block_given?
    end

    # POST /resource/sign_in
    def create
      super

      verify_ts_and_cs_accepted

      return if resource.plots.any?

      sign_out_all_scopes
      flash[:alert] = t(".no_plot")
    end

    def update
      development = DevelopmentFinderService.call(params)
      @brand = development&.brand_any

      super
    end

    # DELETE /resource/sign_out
    def destroy
      @plot = Plot.find(session[:plot_id]) if session[:plot_id]
      super
    end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

    private

    def verify_ts_and_cs_accepted
      return if current_resident.blank?
      return if current_resident.ts_and_cs_accepted_at.present?

      if params[:resident][:ts_and_cs_accepted_at]
        current_resident.update(ts_and_cs_accepted_at: Time.zone.now)
        # Set a generic cookie, not a devise session, because the devise session data
        # is removed on log out, and we need this to persist through log out to the next user
        # log in.
        # WARNING Cookies are stored in the clear (do not include confidential information)
        cookies[:ts_and_cs_accepted] = current_resident.ts_and_cs_accepted_at.present?
      else
        # If the device is shared, a user might get here by signing in with a different email
        # address. They will also get here after the rake task reset_ts_and_cs has been run
        # If so, delete the cookie and send them back to log in again
        cookies.delete :ts_and_cs_accepted
        sign_out_all_scopes
        flash[:alert] = t(".ts_and_cs_required")
      end
    end
  end
end
