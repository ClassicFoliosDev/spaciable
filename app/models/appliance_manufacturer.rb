# frozen_string_literal: true
class ApplianceManufacturer < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  delegate :to_s, to: :name
end
