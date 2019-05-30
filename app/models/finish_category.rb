# frozen_string_literal: true

class FinishCategory < ApplicationRecord
  has_many :finish_categories_type
  has_many :finish_types, through: :finish_categories_type
  has_many :manufacturers, through: :finish_types
  has_many :room_items, as: :room_itemable

  belongs_to :finish, optional: true

  validates :name, presence: true, uniqueness: true

  delegate :to_s, to: :name
end
