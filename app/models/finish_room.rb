# frozen_string_literal: true

class FinishRoom < ApplicationRecord
  self.table_name = "finishes_rooms"

  belongs_to :finish, inverse_of: :finish_rooms
  belongs_to :room, inverse_of: :finish_rooms

  after_initialize :set_default_adding_user

  after_create -> { log :added }
  after_update -> { log :updated }
  after_destroy -> { log :removed }

  scope :room_finish,
        lambda { |room, finish|
          find_by(room_id: room, finish_id: finish)
        }

  attr_accessor :search_finish_text

  validates :finish, uniqueness: { scope: :room }, on: :create
  validates :finish, presence: true
  validates :room, presence: true

  # set a default adding user - this is for situations where associations
  # are updated and result in new records being added
  def set_default_adding_user
    self.added_by ||= User.find_by(role: :cf_admin).display_name
  end

  def self.author(room, finish)
    room_finish(room, finish).added_by
  rescue
    nil
  end

  private

  def log(action)
    room.furnish_log(finish, action)
  end
end
