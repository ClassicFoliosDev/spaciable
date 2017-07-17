# frozen_string_literal: true
class Appliance < ApplicationRecord
  acts_as_paranoid

  include PgSearch
  multisearchable against: [:name, :model_num], using: [:tsearch, :trigram]

  mount_uploader :primary_image, PictureUploader
  mount_uploader :secondary_image, PictureUploader
  mount_uploader :manual, DocumentUploader
  mount_uploader :guide, DocumentUploader
  process_in_background :primary_image
  process_in_background :secondary_image
  process_in_background :manual
  process_in_background :guide

  attr_accessor :primary_image_cache
  attr_accessor :secondary_image_cache

  belongs_to :appliance_category, required: true
  belongs_to :appliance_manufacturer, required: true

  has_many :appliance_rooms
  has_many :rooms, through: :appliance_rooms

  paginates_per 10

  validates :model_num, presence: true, uniqueness: true

  delegate :link, to: :appliance_manufacturer, prefix: true

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

  def full_name
    "#{appliance_manufacturer&.name} #{model_num}".strip
  end

  def to_s
    full_name
  end

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end
end
