# frozen_string_literal: true

# rubocop:disable Rails/HasManyOrHasOneDependent
class Referral < ApplicationRecord
  has_many :referrals

  def self.delete_28_days_old
    Referral.where("created_at < ?", 28.days.ago).where(email_confirmed: false).destroy_all
  end

  def set_confirmation_token
    self.confirm_token = SecureRandom.urlsafe_base64.to_s if confirm_token.blank?
  end

  def validate_referral
    self.email_confirmed = true
    self.confirm_token = nil
  end
end
# rubocop:enable Rails/HasManyOrHasOneDependent
