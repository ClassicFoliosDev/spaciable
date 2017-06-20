# frozen_string_literal: true
class FinishType < ApplicationRecord
  has_many :finish_categories_type
  has_many :finish_categories, through: :finish_categories_type

  has_many :finish_types_manufacturer
  has_many :manufacturers, through: :finish_types_manufacturer

  attr_accessor :finish_category_id
  default_scope { order(name: :asc) }

  validates :name, presence: true, uniqueness: true
  validates :finish_category_id, presence: true

  delegate :to_s, to: :name
end
