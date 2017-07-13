# frozen_string_literal: true
class ApplianceManufacturer < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  delegate :to_s, to: :name
end
