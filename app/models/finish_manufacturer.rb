# frozen_string_literal: true

# rubocop:disable Rails/HasManyOrHasOneDependent
class FinishManufacturer < ApplicationRecord
  has_many :finish_types_manufacturer
  has_many :finish_types, through: :finish_types_manufacturer, dependent: :destroy
  has_many :finish_categories, through: :finish_types
  belongs_to :developer, optional: true

  scope :with_type,
        lambda { |type|
          joins(:finish_types)
            .where(finish_types: { id: type })
            .order(:name)
        }

  validates :finish_types, length: { minimum: 1 }
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  delegate :to_s, to: :name
end
# rubocop:enable Rails/HasManyOrHasOneDependent
