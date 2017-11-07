# frozen_string_literal: true

module Homeowners
  class ResidentsController < Homeowners::BaseController
    def show
      @services = Service.all
    end

    def edit
      @services = Service.all.includes(:residents)
    end

    def update
      if UpdateUserService.call(current_resident, resident_params)
        Mailchimp::MarketingMailService.call(current_resident)
        notice = t(".success")
        notice += process_service_ids(params[:services])
        redirect_to root_path, notice: notice
      else
        render :edit
      end
    end

    private

    def process_service_ids(service_params)
      service_ids = []

      # The service params are wrapped in an array, all
      # the ids are in the first entry
      service_params&.first&.each do |param|
        service_ids.push(param.to_i)
      end

      service_count = ResidentServicesService.call(current_resident, service_ids, true)
      return t(".updated_services") if service_count.positive?

      ""
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resident_params
      params.require(:resident).permit(
        :title,
        :first_name,
        :last_name,
        :password,
        :password_confirmation,
        :current_password,
        :developer_email_updates,
        :hoozzi_email_updates,
        :telephone_updates,
        :post_updates
      )
    end
  end
end
