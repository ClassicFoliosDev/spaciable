# frozen_string_literal: true
class Room < ApplicationRecord
  acts_as_paranoid

  belongs_to :unit_type, optional: false
  belongs_to :development, optional: true
  belongs_to :division, optional: true
  belongs_to :developer, optional: false

  alias parent unit_type
  include InheritParentPermissionIds

  enum icon_name: [
    :bedroom,
    :bathroom,
    :kitchen,
    :living_room,
    :dining_room,
    :study
  ]

  has_many :finish_rooms
  has_many :finishes, through: :finish_rooms

  has_many :appliance_rooms
  has_many :appliances, through: :appliance_rooms

  has_many :documents, as: :documentable, dependent: :destroy
  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
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
