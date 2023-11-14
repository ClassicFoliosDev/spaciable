# frozen_string_literal: true

module Homeowners
  class PerksController < Homeowners::BaseController
    after_action only: %i[show] do
      record_event(:view_buyers_club,
                   category1: I18n.t("ahoy.#{Ahoy::Event::BC_FIND_OUT_MORE}"))
    end

    before_action only: %i[create] do
      record_event(:view_buyers_club,
                   category1: I18n.t("ahoy.#{Ahoy::Event::BC_GIVE_ME_ACCESS}"),
                   category2: account_params[:access_type])
    end

    def show
      redirect_to dashboard_path if params[:type].blank? || !@plot.enable_perks? || @plot.free?
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
            render status: :ok,
                   json: { url: dashboard_path }.to_json
          end
        end
      end
      increment_sign_up_count
    end

    private

    def increment_sign_up_count
      PremiumPerk.increment_sign_up(account_params[:group]) if
        account_params[:access_type] == Vaboo::PREMIUM
    end

    def account_params
      params.require(:perk)
            .permit(:first_name, :last_name, :email,
                    :postcode, :group, :reference,
                    :expire_date, :access_type, :developer)
    end
  end
end
