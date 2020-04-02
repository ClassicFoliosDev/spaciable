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
  delegate :company_name, to: :developer
  delegate :cas, to: :developer
  delegate :enable_roomsketcher, :house_search, :development_faqs, to: :developer
  delegate :enable_referrals, :enable_services, :enable_development_messages, to: :developer
  delegate :enable_perks, to: :developer

  after_destroy { User.permissable_destroy(self.class.to_s, id) }

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

  def admin_list
    admins = User.admins(self)

    # add development admins
    developments.each do |development|
      admins += User.admins(development)
    end

    admins
  end

  # Any admin of this divsion can potentially be the
  # prime letting admin
  def potential_prime_admins
    User.where(permission_level_type: Division.to_s,
               permission_level_id: id,
               role: User.roles[:division_admin])
  end

  # Any development admin assocaited with a top level developmment for
  # this developer can potentially be a branch letting admin
  def potential_branch_admins
    User.where(permission_level_type: Development.to_s,
               permission_level_id: developments.pluck(:id),
               role: User.roles[:development_admin])
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
end
