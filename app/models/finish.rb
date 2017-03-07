# frozen_string_literal: true
class Finish < ApplicationRecord
  acts_as_paranoid

  belongs_to :room
  alias parent room
  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache

  belongs_to :developer, optional: true
  belongs_to :division, optional: true
  belongs_to :development, optional: true

  belongs_to :finish_category, optional: false
  belongs_to :finish_type, optional: false
  belongs_to :manufacturer

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end
end
