# frozen_string_literal: true
class Phase < ApplicationRecord
  attribute :number, :integer

  acts_as_paranoid

  belongs_to :development, optional: false, counter_cache: true
  belongs_to :developer, optional: false
  belongs_to :division, optional: true

  has_many :phases_unit_types
  has_many :unit_types, through: :phases_unit_types
  has_one :address, as: :addressable

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  before_validation :set_number, :set_permissable_ids

  validates :name, :number, presence: true
  validate :permissable_id_presence
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

  def permissable_id_presence
    return unless developer_id.blank? && division_id.blank?
    errors.add(:base, :missing_permissable_id)
  end

  def set_number
    return self[:number] if self[:number].present?
    return self[:number] = 1 unless development

    self[:number] = development.phases.count + 1
  end

  def number
    self[:number] || set_number
  end

  def set_permissable_ids
    return unless development.present?
    self.division_id = development.division_id
    self.developer_id = development.developer_id unless division_id
  end

  def to_s
    name
  end
end
