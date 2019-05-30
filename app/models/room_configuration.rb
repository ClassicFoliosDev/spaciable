# frozen_string_literal: true

class RoomConfiguration < ApplicationRecord
  include RoomEnum

  belongs_to :choice_configuration, optional: false
  has_many :room_items, dependent: :destroy
  delegate :to_s, to: :name

  def room
    name
  end
end
