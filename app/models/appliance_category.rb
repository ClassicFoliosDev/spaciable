# frozen_string_literal: true

class ApplianceCategory < ApplicationRecord
  belongs_to :appliance, optional: true
  has_many :room_items, as: :room_itemable
  belongs_to :developer, optional: true

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
