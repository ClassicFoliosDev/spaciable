# frozen_string_literal: true

# rubocop:disable Rails/HasManyOrHasOneDependent
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
end
# rubocop:enable Rails/HasManyOrHasOneDependent
