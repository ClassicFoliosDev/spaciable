# frozen_string_literal: true
class ApplianceCategory < ApplicationRecord
  has_many :appliance_categories_manufacturer
  has_many :manufacturers, through: :appliance_categories_manufacturer

  belongs_to :appliance, optional: true

  validates :name, uniqueness: true

  def to_s
    name
  end
end
