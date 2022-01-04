# frozen_string_literal: true

class FinishType < ApplicationRecord
  has_many :finish_categories_type
  has_many :finish_categories, through: :finish_categories_type, dependent: :destroy

  has_many :finish_types_manufacturer
  has_many :finish_manufacturers, through: :finish_types_manufacturer, dependent: :destroy
  has_many :manufacturers, through: :finish_types_manufacturer

  scope :with_category,
        lambda { |category|
          joins(:finish_categories)
            .where(finish_categories: { id: category })
            .order(:name)
        }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :finish_categories, length: { minimum: 1 }

  delegate :to_s, to: :name

  def self.find_or_create(name, developer, category)
    type = FinishType.find_or_initialize_by(name: name, developer_id: developer)
    type.finish_category_ids |= [category.id] # add if unique
    type.save!
    type
  end
end
