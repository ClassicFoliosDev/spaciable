# frozen_string_literal: true
class UnitType < ApplicationRecord
  acts_as_paranoid
  belongs_to :development, optional: false
  alias parent development
  include InheritParentPermissionIds
  mount_uploader :picture, PictureUploader

  belongs_to :developer, optional: false
  belongs_to :division, optional: true

  has_many :rooms, dependent: :destroy
  has_many :plots, dependent: :destroy
  has_many :phases_unit_types
  has_many :phases, through: :phases_unit_types
  has_many :documents, as: :documentable
  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true
  has_many :images, as: :imageable
  accepts_nested_attributes_for :images, reject_if: :all_blank, allow_destroy: true

  enum build_type: [
    :apartment,
    :coach_house,
    :house_detached,
    :house_semi,
    :house_terraced,
    :maisonette,
    :penthouse,
    :studio
  ]

  validates :name, presence: true

  def to_s
    name
  end
end
