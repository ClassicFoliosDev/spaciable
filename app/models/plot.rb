# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
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

  has_many :plot_residencies, dependent: :destroy
  has_many :plot_private_documents, dependent: :destroy
  has_many :private_documents, through: :plot_private_documents
  has_many :plot_documents, dependent: :destroy
  has_many :documents, through: :plot_documents
  has_many :residents, through: :plot_residencies

  has_many :unit_types, through: :development
  has_many :plot_rooms, class_name: "Room"
  has_many :finishes, through: :rooms
  has_many :documents, as: :documentable
  has_one :address, as: :addressable, dependent: :destroy

  attr_accessor :notify

  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  validates :number, presence: true
  validates :unit_type, presence: true
  validates :validity, :extended_access, numericality: {
    greater_than_or_equal_to: 0, only_integer: true
  }
  validates_with PlotCombinationValidator

  delegate :picture, to: :unit_type, prefix: true
  delegate :external_link, to: :unit_type
  delegate :branded_logo, to: :brand, allow_nil: true
  delegate :maintenance_link, to: :development, allow_nil: true
  delegate :house_search, :enable_services?, to: :developer, allow_nil: true
  delegate :enable_development_messages?, to: :developer

  enum progress: %i[
    soon
    in_progress
    roof_on
    exchange_ready
    complete_ready
    completed
    remove
  ]

  def rooms(room_scope = Room.all)
    templated_room_ids = plot_rooms.with_deleted.pluck(:template_room_id).compact
    unit_type_rooms_relation = room_scope
                               .where(unit_type_id: unit_type_id)
                               .where.not(id: templated_room_ids)

    room_scope.where(plot_id: id).or(unit_type_rooms_relation)
  end

  # ADDRESSES

  delegate :address, to: :parent, prefix: :parent, allow_nil: true
  delegate :locality, :city, :county, to: :parent, allow_nil: true
  delegate :api_key, to: :developer, allow_nil: true

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

  def postal_number
    return house_number if house_number
    if address&.postal_number?
      address.postal_number
    else
      parent.address&.postal_number
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

  def locality=(_); end

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

  def brand
    development&.brand || division&.brand || developer&.brand || Brand.new
  end

  def <=>(other)
    PlotCompareService.call(self, other)
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

  def private_document_count
    residents.map { |resident| resident&.private_documents&.count.to_i }.sum
  end

  def expiry_date
    return if completion_release_date.blank?
    completion_release_date + validity.months + extended_access.months
  end

  def show_maintenance?
    return false if maintenance_link.blank?
    return true if expiry_date.blank?
    Time.zone.today < expiry_date
  end

  def to_s
    if prefix.blank?
      number.to_s
    else
      "#{prefix} #{number}"
    end
  end

  def activated_resident_count
    residents.where.not(invitation_accepted_at: nil).count
  end

  def to_homeowner_s
    if house_number.present?
      if building_name.present?
        "#{house_number} #{building_name}"
      else
        "#{house_number} #{road_name}".strip
      end
    elsif building_name.present?
      "#{building_name} (#{self})"
    else
      "#{road_name} (#{self})".strip
    end
  end
end
# rubocop:enable Metrics/ClassLength
