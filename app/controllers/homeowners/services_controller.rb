# frozen_string_literal: true

module Homeowners
  class ServicesController < Homeowners::BaseController
    skip_authorization_check

    layout "accept"

    def index
      @services = Service.all
    end

    def resident_services
      service_count = ResidentServicesService
                      .call(current_resident, params[:services], false, @plot)

      notice = t(".success") if service_count.positive?
      redirect_to root_path, notice: notice
    end
  end
end
