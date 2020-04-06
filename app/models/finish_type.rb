# frozen_string_literal: true

class FinishType < ApplicationRecord
  has_many :finish_categories_type
  has_many :finish_categories, through: :finish_categories_type, dependent: :destroy

  has_many :finish_types_manufacturer
  has_many :finish_manufacturers, through: :finish_types_manufacturer, dependent: :destroy
  has_many :manufacturers, through: :finish_types_manufacturer

  belongs_to :developer, optional: true

  scope :visible_to,
        lambda { |user|
          where("developer_id #{user.developer.nil? ? 'IS NULL' : '=' + user.developer.to_s}")
        }

  scope :with_category,
        lambda { |category|
          joins(:finish_categories)
            .where(finish_categories: { id: category })
            .order(:name)
        }

  validates :name, presence: true,
                   uniqueness:
                   {
                     scope: %i[developer],
                     case_sensitive: false
                   }
  validates :finish_categories, length: { minimum: 1 }

  delegate :to_s, to: :name
end
