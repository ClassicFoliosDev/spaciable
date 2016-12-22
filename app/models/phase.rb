# frozen_string_literal: true
class Phase < ApplicationRecord
  attribute :number, :integer

  acts_as_paranoid

  belongs_to :development, optional: false, counter_cache: true
  alias parent development
  include InheritParentPermissionIds

  belongs_to :developer, optional: false
  belongs_to :division, optional: true

  has_many :phases_unit_types
  has_many :unit_types, through: :phases_unit_types
  has_many :document, as: :documentable
  has_one :address, as: :addressable

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  before_validation :set_number

  validates :name, :number, presence: true
  validates :number,
            uniqueness: { scope: :development_id }

  def build_address_with_defaults
    return if address.present?
    return build_address if !development || !development.address

    address_fields = [:postal_name, :building_name, :road_name, :city, :county, :postcode]
    address_attributes = development.address.attributes.select do |key, _|
      address_fields.include?(key.to_sym)
    end

    build_address(address_attributes)
  end

  def set_number
    return self[:number] if self[:number].present?
    return self[:number] = 1 unless development

    self[:number] = development.phases.count + 1
  end

  def number
    self[:number] || set_number
  end

  def to_s
    name
  end
end
