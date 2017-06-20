# frozen_string_literal: true
class FinishCategory < ApplicationRecord
  has_many :finish_categories_type
  has_many :finish_types, through: :finish_categories_type
  has_many :manufacturers, through: :finish_types

  belongs_to :finish, optional: true
  default_scope { order(name: :asc) }

  validates :name, presence: true, uniqueness: true

  delegate :to_s, to: :name
end
