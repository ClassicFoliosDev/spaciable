# frozen_string_literal: true
class Finish < ApplicationRecord
  # acts_as_paranoid oes not work for nested fields
  belongs_to :room
  alias parent room
  mount_uploader :picture, PictureUploader

  belongs_to :developer, optional: true
  belongs_to :division, optional: true
  belongs_to :development, optional: true

  belongs_to :finish_category
  belongs_to :finish_type
  belongs_to :manufacturer

  # has_many :documents, as: :documentable
  # accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true

  def to_s
    name
  end
end
