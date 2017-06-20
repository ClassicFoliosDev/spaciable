# frozen_string_literal: true
class Finish < ApplicationRecord
  acts_as_paranoid

  include PgSearch
  multisearchable against: [:name], using: [:tsearch, :trigram]

  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache

  belongs_to :finish_category, optional: false
  belongs_to :finish_type, optional: false
  belongs_to :manufacturer

  has_many :finish_rooms
  has_many :rooms, through: :finish_rooms
  has_many :unit_types, through: :rooms

  validates :name, presence: true, uniqueness: true
  default_scope { order(name: :asc) }

  def to_s
    name
  end

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end
end
