# frozen_string_literal: true
class ApplianceRoom < ApplicationRecord
  self.table_name = "appliances_rooms"

  belongs_to :appliance
  belongs_to :room
end
