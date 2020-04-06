# frozen_string_literal: true

module ReferralHelper
  def data_for_referral(resident, plot)
    {
      cancel: t("edit.cancel"),
      cta: t("homeowners.components.referrals.send_invitation"),
      title: t("homeowners.components.referrals.refer_title"),
      description: t("homeowners.components.referrals.description"),
      referrer_name: "#{resident.first_name} #{resident.last_name}",
      referrer_email: resident.email,
      referrer_developer: plot.developer,
      referrer_address: "#{plot.referrer_address}, Plot #{plot.id}: #{plot.to_homeowner_s}",
      referral_date: Time.now
    }
  end
end
