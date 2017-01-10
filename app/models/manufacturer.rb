# frozen_string_literal: true
class Manufacturer < ApplicationRecord
  has_many :finish_types_manufacturer
  has_many :finish_types, through: :finish_types_manufacturer
  has_many :finish_categories, through: :finish_types
  has_many :appliance_categories_manufacturer
  has_many :appliance_categories, through: :appliance_categories_manufacturer

  validates :name, uniqueness: true
end
