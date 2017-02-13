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

  has_one :plot_residency
  delegate :resident, to: :plot_residency, allow_nil: true

  has_many :unit_types, through: :development
  has_many :rooms, through: :unit_type
  has_many :finishes, through: :rooms
  has_many :documents, as: :documentable
  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  validates :number, presence: true

  delegate :build_resident, to: :build_plot_residency

  # `1.0` becomes `1`
  # `1.1` stays as `1.1`
  def number
    return self[:number] unless self[:number].to_i == self[:number]
    self[:number].to_i
  end

  def build_address_with_defaults
    return if address.present?
    return build_address if !parent || !parent.address

    address_fields = [:postal_name, :building_name, :road_name, :city, :county, :postcode]
    address_attributes = parent.address.attributes.select do |key, _|
      address_fields.include?(key.to_sym)
    end

    build_address(address_attributes)
  end

  def keep_parent_address(plot_parent)
    self.parent = plot_parent

    if address&.to_plot_s == parent.address&.to_plot_s
      # Make sure we don't save the address if it hasn't changed
      self.address = nil
    else
      # City and county are always inherited, and can not be overwritten
      address&.city = parent.address&.city
      address&.county = parent.address&.county
    end
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
