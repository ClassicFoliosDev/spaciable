# frozen_string_literal: true

class BrandedPerk < ApplicationRecord
  mount_uploader :tile_image, PictureUploader
  attr_accessor :tile_image_cache

  validates :link, :account_number, presence: true
end
