# frozen_string_literal: true
class Plot < ApplicationRecord
  acts_as_paranoid

  belongs_to :phase, optional: true
  belongs_to :development, optional: false
  def parent
    phase || development
  end
  include InheritParentPermissionIds

  belongs_to :unit_type, optional: true
  belongs_to :developer, optional: false
  belongs_to :division, optional: true

  has_one :plot_residency, dependent: :destroy
  delegate :resident, to: :plot_residency, allow_nil: true

  has_many :unit_types, through: :development
  has_many :rooms, through: :unit_type
  has_many :finishes, through: :rooms
  has_many :documents, as: :documentable
  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  validates :number, presence: true
  validates :unit_type, presence: true
  validates_with PlotCombinationValidator

  delegate :build_resident, to: :build_plot_residency
  delegate :picture, to: :unit_type, prefix: true

  # ADDRESSES

  delegate :address, to: :parent, prefix: :parent, allow_nil: true
  delegate :city, :county, to: :parent, allow_nil: true
  alias postal_name house_number

  def building_name
    if address&.building_name?
      address.building_name
    else
      parent.building_name
    end
  end

  def road_name
    if address&.road_name?
      address.road_name
    else
      parent.road_name
    end
  end

  def postcode
    if address&.postcode?
      address.postcode
    else
      parent.postcode
    end
  end

  def building_name=(name)
    return if parent_address && name == parent_address.building_name
    (address || build_address).building_name = name
  end

  def road_name=(name)
    return if parent_address && name == parent_address.road_name
    (address || build_address).road_name = name
  end

  def city=(_); end

  def county=(_); end

  def postcode=(name)
    return if parent_address && name == parent_address.postcode
    (address || build_address).postcode = name
  end

  def number
    return if self[:number].blank?
    BulkPlots::Numbers.Number(self[:number])
  end

  def number=(int_or_float)
    self[:number] = BulkPlots::Numbers.Number(int_or_float)
  end

  def parent=(object)
    case object
    when Phase
      self.phase = object
      self.development = nil
    when Development
      self.phase = nil
      self.development = object
    end
  end

  def to_s
    if prefix.blank?
      number.to_s
    else
      "#{prefix} #{number}"
    end
  end
end
