# frozen_string_literal: true
class Manufacturer < ApplicationRecord
  has_many :finish_types_manufacturer
  has_many :finish_types, through: :finish_types_manufacturer
  has_many :finish_categories, through: :finish_types
  has_many :appliance_categories_manufacturer
  has_many :appliance_categories, through: :appliance_categories_manufacturer

  attr_accessor :assign_to_appliances, :finish_category_id

  scope :for_finishes, -> { joins(:finish_types).distinct }
  scope :for_appliances, -> { joins(:appliance_categories).distinct }

  validates :name, presence: true, uniqueness: true
  validate :required_fields

  delegate :to_s, to: :name

  def required_fields
    return unless assign_to_appliances == "false"
    return unless finish_category_id.blank?

    errors.add(:finish_category_id, :required_if_finish)
  end
end
