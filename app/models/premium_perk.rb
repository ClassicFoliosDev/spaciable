# frozen_string_literal: true

class PremiumPerk < ApplicationRecord
  belongs_to :development

  validates :premium_licences_bought, numericality: {
    greater_than_or_equal_to: 1, only_integer: true
  }, if: proc { |p| p.enable_premium_perks == true }
  validates :premium_licence_duration, numericality: {
    greater_than_or_equal_to: 1, only_integer: true
  }, if: proc { |p| p.enable_premium_perks == true }

  def self.increment_sign_up(development)
    account = PremiumPerk.find_by(development_id: development)
    return unless account
    account.update_attributes(sign_up_count: (account.sign_up_count + 1))
  end
end
