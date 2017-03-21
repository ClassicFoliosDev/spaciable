# frozen_string_literal: true
module Residents
  class SessionsController < Devise::SessionsController
    layout "login"

    skip_before_action :redirect_residents

    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    def new
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      yield resource if block_given?
    end

    # POST /resource/sign_in
    def create
      super
      return unless resource.plot.nil?

      sign_out_all_scopes
      flash[:alert] = t(".no_plot")
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
