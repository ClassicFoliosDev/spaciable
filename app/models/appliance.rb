# frozen_string_literal: true
class Appliance < ApplicationRecord
  acts_as_paranoid
  mount_uploader :primary_image, PictureUploader
  mount_uploader :secondary_image, PictureUploader
  mount_uploader :manual, DocumentUploader

  attr_accessor :primary_image_cache
  attr_accessor :secondary_image_cache

  belongs_to :appliance_category, required: true
  belongs_to :manufacturer, required: true

  has_many :appliance_rooms
  has_many :rooms, through: :appliance_rooms

  paginates_per 10

  validates :name, presence: true, uniqueness: true

  enum warranty_length: [
    :no_warranty,
    :one,
    :two,
    :three,
    :four,
    :five,
    :six,
    :seven,
    :eight,
    :nine,
    :ten
  ]

  enum e_rating: [
    :a3,
    :a2,
    :a1,
    :a,
    :b,
    :c,
    :d
  ]

  def to_s
    name
  end
end
