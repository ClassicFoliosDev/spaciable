# frozen_string_literal: true
class Development < ApplicationRecord
  acts_as_paranoid

  belongs_to :developer, optional: true
  belongs_to :division, optional: true

  include PgSearch
  multisearchable against: [:name], using: [:tsearch, :trigram]

  def parent
    division || developer
  end

  has_many :documents, as: :documentable, dependent: :destroy
  has_many :faqs, as: :faqable
  has_many :phases, dependent: :destroy
  has_many :plots, -> { where(phase_id: nil) }, dependent: :destroy
  has_many :plot_residencies, through: :plots
  has_many :residents, through: :plot_residencies
  has_many :rooms, dependent: :destroy
  has_many :unit_types, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  has_many :contacts, as: :contactable, dependent: :destroy
  has_one :brand, as: :brandable, dependent: :destroy
  has_many :brands, as: :brandable
  has_many :videos, as: :videoable

  has_many :plot_documents, through: :plots, source: :documents

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  scope :by_developer_and_developer_divisions, lambda { |developer_id|
    division_ids = Division.where(developer_id: developer_id).pluck(:id)

    where(developer_id: developer_id).or(where(division_id: division_ids))
  }

  validates :name, presence: true, uniqueness: { scope: [:developer_id, :division_id] }
  validate :permissable_id_presence
  validates_with ParameterizableValidator

  delegate :building_name, :road_name, :city, :county, :postcode, to: :address, allow_nil: true
  delegate :to_s, to: :name

  def brand_any
    return brand if brand
    return parent.brand if parent&.brand
    return parent.parent&.brand if parent.is_a? Division
  end

  def permissable_id_presence
    return unless developer_id.blank? && division_id.blank?
    errors.add(:base, :missing_permissable_id)
  end

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end
end
