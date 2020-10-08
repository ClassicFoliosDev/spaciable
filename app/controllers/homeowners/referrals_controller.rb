# frozen_string_literal: true

module Homeowners
  class ReferralsController < Homeowners::BaseController
    skip_before_action :validate_ts_and_cs, :set_plot, :set_brand,
                       unless: -> { current_resident || current_user }

    after_action only: %i[create] do
      record_event(:refer_a_friend)
    end

    def create
      create_new_referral
    end

    def confirm_referral
      @referral = Referral.find_by(confirm_token: params[:token])
      @referral.validate_referral
      @referral.save(validate: false)
      ReferDeveloperMailer.referral_confirm(@referral).deliver
    end

    private

    def create_new_referral
      @referral = Referral.new(referral_params)
      @referral.save
      @referral.set_confirmation_token
      @referral.save(validate: false)
      send_email
      render json: { notice: t("homeowners.dashboard.tiles.referrals.confirm") }
    end

    def send_email
      ReferDeveloperMailer.refer_developer(@referral, referral_params).deliver
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def referral_params
      params.require(:referral).permit(
        :referee_first_name, :referee_last_name, :referee_email, :referee_phone,
        :referral_date, :referrer_name, :referrer_email, :referrer_developer,
        :referrer_address, :confirm_token, :email_confirmed
      )
    end
  end
end
