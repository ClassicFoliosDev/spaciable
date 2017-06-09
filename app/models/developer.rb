# frozen_string_literal: true
class Developer < ApplicationRecord
  acts_as_paranoid

  include PgSearch
  multisearchable against: [:company_name], using: [:tsearch, :trigram]

  has_many :divisions, dependent: :destroy
  has_many :developments, dependent: :destroy

  has_many :documents, as: :documentable, dependent: :destroy
  has_many :faqs, as: :faqable
  has_many :phases, dependent: :destroy
  has_many :plots, dependent: :destroy
  has_many :plot_residencies, through: :plots
  has_many :residents, through: :plot_residencies
  has_many :rooms, dependent: :destroy
  has_many :unit_types, dependent: :destroy
  has_many :contacts, as: :contactable
  has_one :brand, as: :brandable, dependent: :destroy
  has_many :brands, as: :brandable
  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  validates :company_name, presence: true, uniqueness: true

  delegate :to_s, to: :company_name

  paginates_per 10

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end
end
