# frozen_string_literal: true

class Division < ApplicationRecord
  acts_as_paranoid
  belongs_to :developer

  include PgSearch
  multisearchable against: [:division_name], using: %i[tsearch trigram]

  alias parent developer

  has_many :developments, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :faqs, as: :faqable, dependent: :destroy
  has_many :phases, dependent: :destroy
  has_many :plots, dependent: :destroy
  has_many :plot_residencies, through: :plots
  has_many :residents, through: :plot_residencies
  has_many :rooms, dependent: :destroy
  has_many :unit_types, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  has_many :contacts, as: :contactable, dependent: :destroy
  has_one :brand, as: :brandable, dependent: :destroy
  has_many :brands, as: :brandable

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  validates :division_name, presence: true, uniqueness: { scope: :developer_id }
  validates_with ParameterizableValidator

  delegate :to_s, to: :division_name
  delegate :api_key, :development_faqs, :country, to: :developer

  paginates_per 25

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end

  def expired?
    expired = true
    return expired = false if developments.empty?
    developments.each do |development|
      return expired = false unless development.expired?
    end
  end

  def partially_expired?
    plot_list = []
    plots.each do |plot|
      plot_list << plot if plot.expired?
    end
    return true if plot_list.count.positive?
  end

  def active_plots_count
    active_plots = 0
    phases.each do |phase|
      active_plots += phase.active_plots_count
    end
    active_plots
  end

  def completed_plots_count
    completed_plots = 0
    phases.each do |phase|
      completed_plots += phase.completed_plots_count
    end
    completed_plots
  end

  def expired_plots_count
    expired_plots = 0
    phases.each do |phase|
      expired_plots += phase.expired_plots_count
    end
    expired_plots
  end

  def invited_resident_count
    invited_residents = 0
    phases.each do |phase|
      invited_residents += phase.released_resident_count
    end
    invited_residents
  end

  def activated_resident_count
    activated_residents = 0
    phases.each do |phase|
      activated_residents += phase.activated_resident_count
    end
    activated_residents
  end
end
