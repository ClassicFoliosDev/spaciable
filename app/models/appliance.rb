# frozen_string_literal: true
class Appliance < ApplicationRecord
  acts_as_paranoid
  mount_uploader :primary_image, PictureUploader
  mount_uploader :secondary_image, PictureUploader
  mount_uploader :manual, DocumentUploader

  belongs_to :appliance_category
  belongs_to :manufacturer

  paginates_per 10

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
    :d,
    :e,
    :f,
    :g
  ]

  def to_s
    name
  end
end
