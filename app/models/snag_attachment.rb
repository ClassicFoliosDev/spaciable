# frozen_string_literal: true

class SnagAttachment < ApplicationRecord
  mount_uploader :image, PictureUploader
  belongs_to :snag, optional: false
end
