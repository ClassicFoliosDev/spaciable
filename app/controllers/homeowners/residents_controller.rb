# frozen_string_literal: true
module Homeowners
  class ResidentsController < Homeowners::BaseController
    load_and_authorize_resource :resident

    def show
    end

    def edit
    end

    def update
      if UpdateUserService.call(@resident, resident_params)
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
