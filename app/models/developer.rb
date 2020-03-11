# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Developer < ApplicationRecord
  acts_as_paranoid

  attr_accessor :personal_app

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
  has_one :branded_app, as: :app_owner, dependent: :destroy
  has_many :branded_apps, as: :app_owner

  has_one :lettings_account, as: :letter
  has_many :lettings, through: :lettings_account
  delegate :management, to: :lettings_account

  delegate :apple_link, :android_link, :app_icon, to: :branded_app, prefix: true

  has_one :branded_perk, dependent: :destroy
  accepts_nested_attributes_for :branded_perk, reject_if: :all_blank, allow_destroy: true
  delegate :link, :account_number, :tile_image,
           to: :branded_perk, allow_nil: true, prefix: true

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

  def developments_count
    all_developments.count
  end

  def admin_list
    admins = User.admins(self)

    # add division and development admins
    [divisions, developments].each do |levels|
      levels.each do |level|
        admins += User.admins(level)
      end
    end

    admins
  end

  # If a developer has top level developments, then any admin of this
  # developer can potentially be the prime letting admin
  def potential_prime_admins
    User.where(permission_level_type: Developer.to_s,
               permission_level_id: id,
               role: "developer_admin")
  end

  # Any development admin assocaited with a top level developmment for
  # this developer can potentially be a branch letting admin
  def potential_branch_admins
    User.where(permission_level_type: Development.to_s,
               permission_level_id: developments.pluck(:id),
               role: "development_admin")
  end

  # Expose prime_lettings_admin as a non model attribute so
  # as the developer edit page can get/set it.  The
  # prime_lettings_admin is a user whose lettings_management
  # status is set to 'prime'
  def prime_lettings_admin # getter method
    User.prime_admin(potential_prime_admins.pluck(:id))&.id
  end

  # This is called by 'update' when it sets the
  # Developer attributes
  def prime_lettings_admin=(prime_id) # setter method
    User.update_prime_admin(potential_prime_admins.pluck(:id),
                            prime_id&.to_i)
  end

  def branded_app?
    branded_app = BrandedApp.find_by(app_owner_type: "Developer", app_owner_id: id)
    branded_app.present?
  end
end
# rubocop:enable Metrics/ClassLength
