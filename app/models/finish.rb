# frozen_string_literal: true

class Finish < ApplicationRecord
  acts_as_paranoid

  include PgSearch
  multisearchable against: [:name], using: %i[tsearch trigram]

  mount_uploader :picture, PictureUploader
  process_in_background :picture
  attr_accessor :picture_cache

  belongs_to :finish_category, required: true
  belongs_to :finish_type, required: true
  belongs_to :finish_manufacturer

  has_many :finish_rooms, inverse_of: :finish, dependent: :delete_all
  has_many :rooms, through: :finish_rooms

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end
end
