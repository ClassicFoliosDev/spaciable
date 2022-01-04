# frozen_string_literal: true

class FinishCategory < ApplicationRecord
  has_many :finish_categories_type
  has_many :finish_types, through: :finish_categories_type, dependent: :destroy
  has_many :manufacturers, through: :finish_types
  has_many :room_items, as: :room_itemable

  belongs_to :finish, optional: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  delegate :to_s, to: :name

  def self.find_or_create(name, developer)
    FinishCategory.find_or_create_by(name: name, developer_id: developer)
  end
end
