# frozen_string_literal: true

class ApplianceCategory < ApplicationRecord
  belongs_to :appliance, optional: true
  has_many :room_items, as: :room_itemable
  belongs_to :developer, optional: true

  scope :visible_to,
        lambda { |user|
          where("(developer_id IS NULL AND (select count(*) from appliance_categories ac " \
                "where ac.name = appliance_categories.name AND ac.developer_id = ?) = 0) OR " \
                "(developer_id IS NOT NULL AND developer_id = ?)",
                user.developer,
                user.developer)
        }

  validates :name, presence: true,
                   uniqueness:
                   {
                     scope: %i[developer],
                     case_sensitive: false
                   }

  def to_s
    name
  end
end
