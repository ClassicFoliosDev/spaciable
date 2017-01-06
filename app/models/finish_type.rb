# frozen_string_literal: true
class FinishType < ApplicationRecord
  has_many :finish_categories_type
  has_many :finish_categories, through: :finish_categories_type

  has_many :finish_types_manufacturer
  has_many :manufacturers, through: :finish_types_manufacturer
end
