# frozen_string_literal: true

class LettingsAccountsController < ApplicationController
  skip_authorization_check

  def create
    # PLANET RENT API
    # We need to send the letting account to Planet Rent before saving it,
    # and when the account is set up on Planet Rent,
    # we then need a callback from them to tell us the account is set up.
    # We then save the letting account to the database
    # and flash a notice confirming the account setup
    @lettings_account = LettingsAccount.new(lettings_account_params)
    notify_and_redirect if @lettings_account.save
  end

  private

  def notify_and_redirect
    # PLANET RENT API
    # json notice is not rendering here
    # We also need to force a page refresh so that the list of lettable plots is displayed
    # Page is phase_lettings_path(phase id) ~ phases/:phase_id/lettings
    @lettings_account.update_attributes(letter: Developer.find_by(id: current_user.developer))

    render json: { notice: t("lettings.success.lettings_account_confirm") }
  end

  def lettings_account_params
    params.require(:lettings_account).permit(:access_token, :refresh_token, :first_name,
                                             :last_name, :email, :management, :letter_type,
                                             :letter_id)
  end
end
