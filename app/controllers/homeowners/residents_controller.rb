# frozen_string_literal: true
module Homeowners
  class ResidentsController < Homeowners::BaseController
    skip_authorization_check

    def show
    end

    def edit
    end

    def update
      if UpdateUserService.call(current_resident, resident_params)
        Mailchimp::MarketingMailService.call(current_resident,
                                             nil,
                                             nil,
                                             nil)
        redirect_to root_path, notice: t(".success")
      else
        render :edit
      end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def resident_params
      params.require(:resident).permit(
        :title,
        :first_name,
        :last_name,
        :password,
        :password_confirmation,
        :current_password
      )
    end
  end
end
