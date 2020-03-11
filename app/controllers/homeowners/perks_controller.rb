# frozen_string_literal: true

module Homeowners
  class PerksController < Homeowners::BaseController
    def show
      redirect_to dashboard_path if params[:type].blank? || !@plot.enable_perks?
    end

    def create
      # send the POST request to the API
      Vaboo.create_account(account_params) do |error|
        # if no errors returned from the API
        if error.nil?
          flash[:notice] = t("homeowners.dashboard.perks.notice")
        else
          flash[:alert] = error
        end
        respond_to do |format|
          format.json do
            render status: 200,
                   json: { url: dashboard_path }.to_json
          end
        end
      end
    end

    private

    def account_params
      params.require(:perk)
            .permit(:first_name, :last_name, :email,
                    :postcode, :group, :reference,
                    :expire_date, :access_type, :developer)
    end
  end
end
