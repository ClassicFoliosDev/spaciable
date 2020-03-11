# frozen_string_literal: true

class PremiumPerk < ApplicationRecord
  belongs_to :development

  validates :premium_licences_bought, numericality: {
    greater_than_or_equal_to: 1, only_integer: true
  }, if: proc { |p| p.enable_premium_perks == true }
  validates :premium_licence_duration, numericality: {
    greater_than_or_equal_to: 1, only_integer: true
  }, if: proc { |p| p.enable_premium_perks == true }
end
