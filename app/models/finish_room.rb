# frozen_string_literal: true
class FinishRoom < ApplicationRecord
  self.table_name = "finishes_rooms"

  belongs_to :finish
  belongs_to :room

  validates :finish, uniqueness: { scope: :room }
  validates :finish, presence: true
  validates :room, presence: true
end
