# frozen_string_literal: true

module Homeowners
  class ServicesController < Homeowners::BaseController
    skip_authorization_check

    def index
      @services = Service.where.not(category: nil)
    end

    def resident_services
      response = ResidentServicesService
                 .call(current_resident, params[:services], true, @plot)

      if response.blank?
        redirect_to root_path, notice: t(".success")
      else
        redirect_to root_path, alert: response
      end
    end
  end
end
