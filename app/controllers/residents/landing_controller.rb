# frozen_string_literal: true

module Residents
  class LandingController < Devise::SessionsController
    layout "login"

    skip_before_action :redirect_residents

    def new
      redirect_to("http://spaciable.io/")
    end
  end
end
