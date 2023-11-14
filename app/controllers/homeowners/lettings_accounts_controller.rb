# frozen_string_literal: true

module Homeowners
  class LettingsAccountsController < Homeowners::BaseController
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def create
      # Add a letting account then redirect back to the saved
      # landlord listings page
      PlanetRent.add_landlord(account_params) do |data, error|
        # if no errors from the API
        if error.nil?

          # create the new LettingsAccount
          acc_params = account_params.slice("accountable_type",
                                            "accountable_id",
                                            "management").to_h
          account_data = data.slice("reference")
                             .merge(acc_params)

          @account = LettingsAccount.new(account_data)
          if @account.save
            flash[:notice] = t("homeowners.lettings_account.created",
                               username: data["username"])
          else
            flash[:alert] = t("homeowners.lettings_account.failed")
          end
        else
          flash[:alert] = t("homeowners.lettings_account.pr_failed",
                            message: error)
        end

        respond_to do |format|
          format.html { redirect_to(session[:landlordlistings].redirect_url) }
          format.json do
            render status: :ok,
                   json: session[:landlordlistings].redirect_url.to_json
          end
        end
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    private

    def account_params
      params.require(:lettings_account)
            .permit(:first_name, :last_name, :email,
                    :accountable_id, :accountable_type, :management)
    end
  end
end
