# frozen_string_literal: true
class HowTo < ApplicationRecord
  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache

  enum category: [:home, :diy, :lifestyle, :recipes, :cleaning, :outdoors]
  enum feature_numbers: [1, 2, 3, 4, 5, 6]

  validates :title, :summary, :description, presence: true

  delegate :to_s, to: :title

  paginates_per 25
end
