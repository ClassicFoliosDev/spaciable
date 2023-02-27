# frozen_string_literal: true

class FinishRoom < ApplicationRecord
  self.table_name = "finishes_rooms"

  belongs_to :finish, inverse_of: :finish_rooms
  belongs_to :room, inverse_of: :finish_rooms
  has_one :mark, as: :markable, autosave: true, dependent: :destroy

  delegate :marker, to: :mark, allow_nil: true

  amoeba do
    include_association :mark
  end

  after_save :make_mark
  after_create -> { log :added }
  after_update -> { log :updated }
  after_destroy -> { log :removed }

  scope :room_finish,
        lambda { |room, finish|
          find_by(room_id: room, finish_id: finish)
        }

  scope :with_finish,
        lambda { |finish_id|
          where(finish_id: finish_id)
        }

  attr_accessor :search_finish_text

  validates :finish, uniqueness: { scope: :room }, on: :create
  validates :finish, presence: true
  validates :room, presence: true

  def self.marker(room, finish)
    room_finish(room, finish).marker
  rescue
    nil
  end

  private

  def make_mark
    self.mark ||= create_mark(username: RequestStore.store[:current_user]&.full_name,
                              role: RequestStore.store[:current_user]&.role)
  end

  def log(action)
    room.furnish_log(finish, action)
  end
end
