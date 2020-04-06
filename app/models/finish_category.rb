# frozen_string_literal: true

class FinishCategory < ApplicationRecord
  has_many :finish_categories_type
  has_many :finish_types, through: :finish_categories_type, dependent: :destroy
  has_many :manufacturers, through: :finish_types
  has_many :room_items, as: :room_itemable

  belongs_to :finish, optional: true
  belongs_to :developer, optional: true

  scope :visible_to,
        lambda { |user|
          where("developer_id #{user.developer.nil? ? 'IS NULL' : '=' + user.developer.to_s}")
        }

  validates :name, presence: true,
                   uniqueness:
                   {
                     scope: %i[developer],
                     case_sensitive: false
                   }

  delegate :to_s, to: :name
end
