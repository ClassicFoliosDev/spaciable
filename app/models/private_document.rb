# frozen_string_literal: true

class PrivateDocument < ApplicationRecord
  mount_uploader :file, MultiUploader

  belongs_to :resident

  def to_s
    title
  end
end
