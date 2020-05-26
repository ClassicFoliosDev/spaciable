# frozen_string_literal: true

# The Finale is the final stage of a timeline.
class Finale < ApplicationRecord
  mount_uploader :complete_picture, PictureUploader
  mount_uploader :incomplete_picture, PictureUploader
  attr_accessor :complete_picture_cache
  attr_accessor :incomplete_picture_cache

  belongs_to :timeline, optional: false

  amoeba do
    customize(lambda { |original_finale, new_finale|
      if original_finale.complete_picture.present?
        CopyCarrierwaveFile::CopyFileService
          .new(original_finale, new_finale, :complete_picture).set_file
      end
      if original_finale.incomplete_picture.present?
        CopyCarrierwaveFile::CopyFileService
          .new(original_finale, new_finale, :incomplete_picture).set_file
      end
    })
  end
end
