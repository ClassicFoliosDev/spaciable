# frozen_string_literal: true
class Manufacturer < ApplicationRecord
  has_many :finish_types_manufacturer
  has_many :finish_types, through: :finish_types_manufacturer
  has_many :finish_categories, through: :finish_types
end
