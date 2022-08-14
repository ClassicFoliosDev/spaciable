# frozen_string_literal: true

module Residents
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    layout "login"

    # You should configure your model like this:
    # devise :omniauthable, omniauth_providers: [:twitter]

    # You should also create an action method in this controller like this:
    def all
      resident = Resident.from_omniauth(request.env["omniauth.auth"])
      if resident.present?
        sign_in_and_redirect resident, notice: "Signed in via Twitter"
      else
        redirect_to new_resident_registration_url
      end
    end

    # More info at:
    # https://github.com/plataformatec/devise#omniauth

    # GET|POST /resource/auth/twitter
    # def passthru
    #   super
    # end

    # GET|POST /users/auth/twitter/callback
    def failure
      super
    end

    alias_method :twitter, :all

    # protected

    # The path used when OmniAuth fails
    # def after_omniauth_failure_path_for(scope)
    #   super(scope)
    # end
  end
end
