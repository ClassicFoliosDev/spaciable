# frozen_string_literal: true

class ReferDeveloperMailer < ApplicationMailer
  default from: "no-reply@spaciable.com"

  def refer_developer(referral, _referral_params)
    @logo = "Spaciable_full.svg"
    @referrer = referral.referrer_name
    @developer = referral.referrer_developer
    @referee_email = referral.referee_email
    @referee_name = referral.referee_first_name
    @referral_token = referral.confirm_token

    mail to: @referee_email, subject: I18n.t("homeowners.referrals.email_subject",
                                             referrer: @referrer)
  end

  def referral_confirm(referral)
    @referrer_name = referral.referrer_name
    @referrer_email = referral.referrer_email
    @referrer_developer = referral.referrer_developer
    @referrer_address = referral.referrer_address
    @referee_name = referral.referee_first_name + " " + referral.referee_last_name
    @referee_email = referral.referee_email
    @referee_phone = referral.referee_phone
    mail to: "feedback@spaciable.com", subject: I18n.t("homeowners.referrals.internal_subject")
  end
end
