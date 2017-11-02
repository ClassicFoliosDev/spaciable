# frozen_string_literal: true

class ApplianceRoom < ApplicationRecord
  self.table_name = "appliances_rooms"

  belongs_to :appliance
  belongs_to :room, inverse_of: :appliance_rooms

  attr_accessor :search_appliance_text

  validates :appliance, uniqueness: { scope: :room }, on: :create
  validates :appliance, presence: true
  validates :room, presence: true
end
