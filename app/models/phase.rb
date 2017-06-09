# frozen_string_literal: true
class Phase < ApplicationRecord
  attribute :number, :integer

  acts_as_paranoid

  include PgSearch
  multisearchable against: [:name], using: [:tsearch, :trigram]

  belongs_to :development, optional: false, counter_cache: true
  alias parent development
  include InheritParentPermissionIds

  belongs_to :developer, optional: false
  belongs_to :division, optional: true

  has_many :plots
  has_many :plot_residencies, through: :plots
  has_many :residents, through: :plot_residencies
  has_many :plot_documents, through: :plots, source: :documents

  has_many :unit_types, through: :development
  has_many :documents, as: :documentable
  has_one :address, as: :addressable, dependent: :destroy
  has_one :brand, as: :brandable, dependent: :destroy
  has_many :brands, as: :brandable

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  scope :by_developer_and_developer_divisions, lambda { |developer_id|
    division_ids = Division.where(developer_id: developer_id).pluck(:id)

    where(developer_id: developer_id).or(where(division_id: division_ids))
  }

  before_validation :set_number

  validates :name, :number, presence: true, uniqueness: { scope: :development_id }
  validates :number,
            uniqueness: { scope: :development_id }

  delegate :building_name, :road_name, :city, :county, :postcode, to: :address, allow_nil: true
  delegate :to_s, to: :name

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

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end
end
