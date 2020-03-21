# frozen_string_literal: true

class ApplianceRoom < ApplicationRecord
  self.table_name = "appliances_rooms"

  belongs_to :appliance
  belongs_to :room, inverse_of: :appliance_rooms

  after_initialize :set_default_adding_user

  after_create -> { log :added }
  after_update -> { log :updated }
  after_destroy -> { log :removed }

  scope :appliance_room,
        lambda { |room, appliance|
          find_by(room_id: room, appliance_id: appliance)
        }

  attr_accessor :search_appliance_text

  validates :appliance, uniqueness: { scope: :room }, on: :create
  validates :appliance, presence: true
  validates :room, presence: true

  # set a default adding user - this is for situations where associations
  # are updated and result in new records being added
  def set_default_adding_user
    self.added_by ||= User.find_by(role: :cf_admin).display_name
  end

  def self.author(room, appliance)
    appliance_room(room, appliance).added_by
  rescue
    nil
  end

  private

  def log(action)
    room.furnish_log(appliance, action)
  end
end
