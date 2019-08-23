# frozen_string_literal: true

module Homeowners
  class LettingsAccountsController < Homeowners::BaseController
    def create
      # PLANET RENT API
      # We need to send the letting account to Planet Rent before saving it,
      # and when the account is set up on Planet Rent,
      # we then need a callback from them to tell us the account is set up.
      # We then save the letting account to the database,
      # and flash a notice confirming the account setup
      @lettings_account = LettingsAccount.new(lettings_account_params)
      notify_and_redirect if @lettings_account.save
    end

    private

    def notify_and_redirect
      # PLANET RENT API
      # json notice is not rendering here
      # we need to force a page refresh so that the list of lettable plots becomes visible,
      # instead of the account set up page
      # Page is letting_path(homeowner id) ~ homeowners/lettings/:homeowner_id
      @lettings_account.update_attributes(letter: current_resident)

      render json: { notice: t("homeowners.lettings_account.confirm") }
    end

    def lettings_account_params
      params.require(:lettings_account).permit(:access_token, :refresh_token, :first_name,
                                               :last_name, :email, :management, :letter_type,
                                               :letter_id)
    end
  end
end
