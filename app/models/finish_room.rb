# frozen_string_literal: true
class FinishRoom < ApplicationRecord
  self.table_name = "finishes_rooms"

  belongs_to :finish
  belongs_to :room, optional: true, inverse_of: :finish_rooms

  attr_accessor :search_finish_text

  validates :finish, uniqueness: { scope: :room }, on: :create
  validates :finish, presence: true
  validates :room, presence: true
end
