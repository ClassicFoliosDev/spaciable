# frozen_string_literal: true

module Homeowners
  class ServicesController < Homeowners::BaseController
    skip_authorization_check

    def index
      @services_params = build_services_params if current_resident
    end

    private

    def build_services_params
      # params for referral link
      name = [current_resident.first_name, current_resident.last_name].compact.join(" ")
      email = current_resident.email
      phone = current_resident&.phone_number
      developer = @plot.developer
      "?sf_name=#{name}&sf_email=#{email}&sf_telephone=#{phone}&sf_developer=#{developer}"
    end
  end
end
