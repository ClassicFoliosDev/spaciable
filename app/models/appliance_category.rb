# frozen_string_literal: true

# rubocop:disable Rails/HasManyOrHasOneDependent
class ApplianceCategory < ApplicationRecord
  belongs_to :appliance, optional: true
  has_many :room_items, as: :room_itemable

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def to_s
    name
  end

  def washer_dryer?
    name == "Washer Dryer"
  end
end
# rubocop:enable Rails/HasManyOrHasOneDependent
