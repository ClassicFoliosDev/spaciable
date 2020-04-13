# frozen_string_literal: true

class ApplianceRoom < ApplicationRecord
  self.table_name = "appliances_rooms"

  belongs_to :appliance
  belongs_to :room, inverse_of: :appliance_rooms
  has_one :mark, as: :markable, autosave: true, dependent: :destroy

  delegate :marker, to: :mark, allow_nil: true

  amoeba do
    include_association :mark
  end

  before_save :make_mark

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

  def self.marker(room, appliance)
    appliance_room(room, appliance).marker
  rescue
    nil
  end

  private

  # Mark the record with the current user
  def make_mark
    self.mark ||= create_mark(username: RequestStore.store[:current_user]&.full_name,
                              role: RequestStore.store[:current_user]&.role)
  end

  def log(action)
    room.furnish_log(appliance, action)
  end
end
