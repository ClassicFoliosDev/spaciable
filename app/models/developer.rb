# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Developer < ApplicationRecord
  acts_as_paranoid

  include PgSearch
  multisearchable against: [:company_name], using: %i[tsearch trigram]

  has_many :divisions, dependent: :destroy
  has_many :developments, dependent: :destroy

  has_many :documents, as: :documentable, dependent: :destroy
  has_many :faqs, as: :faqable, dependent: :destroy
  has_many :phases, dependent: :destroy
  has_many :plots, dependent: :destroy
  has_many :plot_residencies, through: :plots
  has_many :residents, through: :plot_residencies
  has_many :rooms, dependent: :destroy
  has_many :unit_types, dependent: :destroy
  has_many :contacts, as: :contactable, dependent: :destroy
  has_one :brand, as: :brandable, dependent: :destroy
  has_many :brands, as: :brandable
  has_one :address, as: :addressable, dependent: :destroy

  has_one :lettings_account, as: :letter
  has_many :lettings, through: :lettings_account
  delegate :management, to: :lettings_account

  # A developer belongs to a country - belongs_to adds a number of new helper
  # methods to the class to allow easy access.  eg. you can call @developer.country
  # on a Developer object and it will retrieve the associated country from the Country
  # table.
  belongs_to :country

  amoeba do
    enable
  end

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  validates :company_name, presence: true, uniqueness: true
  validates_with ParameterizableValidator

  delegate :to_s, to: :company_name

  paginates_per 10

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end

  def clone_faqs
    return if development_faqs
    CloneDefaultFaqsJob.perform_later(faqable_type: "Developer",
                                      faqable_id: id,
                                      country_id: country_id)
  end

  def all_developments
    all_developments = []
    all_developments << developments
    divisions.each do |div|
      all_developments << div.developments
    end

    all_developments.to_a.flatten!
  end

  def expired?
    expired = true
    developments = all_developments
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

  def no_lettings_account?
    LettingsAccount.find_by(letter_id: id).nil?
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
      invited_residents += phase.plot_residencies.size
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

  def developments_count
    all_developments.count
  end
end
# rubocop:enable Metrics/ClassLength
