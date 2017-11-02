# frozen_string_literal: true

class Room < ApplicationRecord
  acts_as_paranoid

  belongs_to :plot, optional: true
  belongs_to :unit_type, optional: true, inverse_of: :rooms
  belongs_to :development, optional: true
  belongs_to :division, optional: true
  belongs_to :developer, optional: false

  def parent
    plot || unit_type
  end
  include InheritParentPermissionIds

  enum icon_name: %i[
    bedroom
    bathroom
    kitchen
    living_room
    dining_room
    study
    exterior
    garage
  ]

  has_many :finish_rooms, inverse_of: :room
  has_many :finishes, through: :finish_rooms
  has_many :finish_manufacturers, through: :finishes

  has_many :appliance_rooms, inverse_of: :room
  has_many :appliances, through: :appliance_rooms
  has_many :appliance_manufacturers, through: :appliances
  has_many :appliance_categories, through: :appliances

  amoeba do
    include_association :finish_rooms
    include_association :appliance_rooms
    include_association :documents
  end

  has_many :documents, as: :documentable, dependent: :destroy
  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: %i[unit_type_id plot_id] }
  validates_associated :finish_rooms
  validates_associated :finishes
  validates_associated :appliance_rooms
  validates_associated :appliances

  after_destroy -> { finishes.delete_all }

  def build_finishes
    finishes.build if finishes.none?
  end

  def build_appliances
    appliances.build if appliances.none?
  end

  def to_s
    name
  end
end
