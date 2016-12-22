# frozen_string_literal: true
class Image < ApplicationRecord
  mount_uploader :file, PictureUploader

  belongs_to :imageable, polymorphic: true
  belongs_to :developer
  belongs_to :division, optional: true
  belongs_to :development, optional: true

  validates :file, presence: true
end
