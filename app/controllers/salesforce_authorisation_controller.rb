# frozen_string_literal: true

class SalesforceAuthorisationController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :redirect_residents
  skip_authorization_check

  def oauth_callback
    # placeholder for future OAuth2 authorization
  end
end
