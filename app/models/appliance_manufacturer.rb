# frozen_string_literal: true

class ApplianceManufacturer < ApplicationRecord
  scope :visible_to,
        lambda { |user|
          where("(developer_id IS NULL AND (select count(*) from appliance_manufacturers am " \
                "where am.name = appliance_manufacturers.name AND am.developer_id = ?) = 0) OR " \
                "(developer_id IS NOT NULL AND developer_id = ?)",
                user.developer,
                user.developer)
        }

  belongs_to :developer, optional: true
  validates :name, presence: true,
                   uniqueness:
                   {
                     scope: %i[developer],
                     case_sensitive: false
                   }

  delegate :to_s, to: :name
end
