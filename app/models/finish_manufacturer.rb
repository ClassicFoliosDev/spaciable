# frozen_string_literal: true

class FinishManufacturer < ApplicationRecord
  has_many :finish_types_manufacturer
  has_many :finish_types, through: :finish_types_manufacturer
  has_many :finish_categories, through: :finish_types

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :finish_types, length: { minimum: 1 }

  delegate :to_s, to: :name
end
