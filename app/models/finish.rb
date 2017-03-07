# frozen_string_literal: true
class Finish < ApplicationRecord
  acts_as_paranoid

  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache

  belongs_to :developer, optional: true
  belongs_to :division, optional: true
  belongs_to :development, optional: true

  belongs_to :finish_category, optional: false
  belongs_to :finish_type, optional: false
  belongs_to :manufacturer

  has_many :finish_rooms
  has_many :rooms, through: :finish_rooms

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end
end
