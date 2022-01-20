# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Developer < ApplicationRecord
  acts_as_paranoid

  attr_accessor :personal_app
  after_save :update_development_cas
  after_save :update_custom_tiles
  after_save :update_convayencing

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
  has_many :videos, as: :videoable
  has_many :contacts, as: :contactable, dependent: :destroy
  has_many :timelines, as: :timelineable, dependent: :destroy
  has_one :brand, as: :brandable, dependent: :destroy
  has_many :brands, as: :brandable
  has_one :address, as: :addressable, dependent: :destroy
  has_one :branded_app, as: :app_owner, dependent: :destroy
  has_many :branded_apps, as: :app_owner

  scope :on_package,
        lambda {
          joins(:phases)
            .where(phases: { package: [Phase.packages[:essentials],
                                       Phase.packages[:professional]] })
            .uniq
        }

  has_many :charts, -> { order("id") }, as: :chartable, dependent: :destroy
  accepts_nested_attributes_for :charts

  has_one :lettings_account, as: :letter
  has_many :lettings, through: :lettings_account
  delegate :management, to: :lettings_account
  has_one :crm, dependent: :destroy
  has_one :build_sequence, as: :build_sequenceable

  delegate :apple_link, :android_link, :app_icon, to: :branded_app, prefix: true

  has_one :branded_perk, dependent: :destroy
  accepts_nested_attributes_for :branded_perk, reject_if: :all_blank, allow_destroy: true
  delegate :link, :account_number, :tile_image,
           to: :branded_perk, allow_nil: true, prefix: true

  alias_attribute :identity, :company_name
  delegate :to_s, to: :company_name

  # A developer belongs to a country - belongs_to adds a number of new helper
  # methods to the class to allow easy access.  eg. you can call @developer.country
  # on a Developer object and it will retrieve the associated country from the Country
  # table.
  belongs_to :country
  delegate :time_zone, to: :country
  delegate :build_steps, to: :sequence_in_use

  after_destroy { User.permissable_destroy(self.class.to_s, id) }

  amoeba do
    enable
  end

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  validates :company_name, presence: true, uniqueness: true
  validates :custom_url, presence: true

  validate :check_custom_url_format, :check_unique

  validates :account_manager_contact, phone: true, allow_blank: true
  validate :account_manager
  validates :account_manager_email,
            allow_blank: true,
            format: { with: Devise.email_regexp }

  validate :check_conveyancing

  def check_conveyancing
    return unless conveyancing?

    if wecomplete_sign_in.blank?
      errors.add("WeComplete sign-in URL", "is required, and must not be blank.")
      errors.add(:wecomplete_sign_in, "please populate")
    end

    return if wecomplete_sign_in.present?
    errors.add("Wecomplete Quote URL", "is required, and must not be blank.")
    errors.add(:wecomplete_quote, "please populate")
  end

  # Account manager fields need to be 'all' or 'none'
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def account_manager
    return unless account_manager_name.present? ||
                  account_manager_email.present? ||
                  account_manager_contact.present?

    unless account_manager_name.present? &&
           account_manager_email.present? &&
           account_manager_contact.present?
      errors.add(:account_manager, "Please populate all or none of name, email and contact")
    end

    errors.add(:account_manager_name, "please populate") if account_manager_name.blank?
    errors.add(:account_manager_email, "please populate") if account_manager_email.blank?
    errors.add(:account_manager_contact, "please populate") if account_manager_contact.blank?
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def check_custom_url_format
    return if custom_url.match(/\A[a-z0-9\-_]+\z/)&.present?

    errors[:custom_url] << "can only contain lowercase letters, digits, dashes and underscores"
  end

  def check_unique
    developer = Developer.find_by(custom_url: custom_url)
    return if developer.blank? || developer == self

    errors[:custom_url] << "is in use for #{developer.company_name}. Please use something unique."
  end

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

    all_developments = all_developments.to_a.flatten!.reject { |d| d.name.nil? }
    all_developments.sort_by(&:name)
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

  def faq_types
    faq_types = FaqType.for_country(country).to_a
    if all_developments.select(&:commercial?).count.zero?
      faq_types.delete_if { |t| t.construction_type.commercial? }
    end
    faq_types
  end

  # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
  def supports?(feature)
    return false unless feature

    case feature.to_sym
    when :area_guide
      house_search?
    when :home_designer
      enable_roomsketcher?
    when :referrals
      enable_referrals?
    when :services
      enable_services?
    when :buyers_club
      enable_perks?
    when :conveyancing, :conveyancing_quote, :conveyancing_signin
      conveyancing_enabled?
    when :custom_url, :issues, :snagging, :tour, :calendar
      true
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity

  # What Content Proformas are available to this developer
  def proformas
    Timeline.available_to(self, StageSet.stage_set_types[:proforma])
  end

  def conveyancing_enabled?
    conveyancing
  end

  def build
    build_address unless address
    build_branded_perk unless branded_perk

    return unless charts.empty?
    Chart.sections.each { |s, _| charts.build(section: s, enabled: true) }
  end

  def chart?(section)
    charts.find_by(section: section)&.enabled
  end

  # Update all the plots for this developer, except for
  # those in a division with their own custom build set.
  # Set the old build stepids to the new build_step id.
  # rubocop:disable SkipsModelValidations, LineLength
  def update_build_steps(old_ids, new_id)
    @updated ||= []
    # only update plots with no division, or a division without
    # a specialised build sequence
    @divs ||= [nil] + plots.where.not(division_id:
                                      BuildSequence.where(build_sequenceable_type: "Division",
                                                          build_sequenceable_id: divisions)
                                                   .pluck(:build_sequenceable_id)).pluck(:division_id).uniq

    targets = plots.where.not(id: @updated)
                   .where(build_step_id: old_ids)
                   .where(division_id: @divs)

    @updated += targets.pluck(:id)
    targets.update_all(build_step_id: new_id)
  end
  # rubocop:enable SkipsModelValidations, LineLength

  def sequence_in_use
    build_sequence || Global.root.build_sequence
  end

  private

  # Use the 'dirty' attribute to check for change to the CAS enablement and
  # proliferate through to all child developments
  # rubocop:disable SkipsModelValidations
  def update_development_cas
    return unless cas_changed?

    # update all developments to have cas on
    all_developments.each { |d| d.update_attribute(:cas, cas) }

    # Migrate finishes for the developer if CAS
    return unless cas
  end
  # rubocop:enable SkipsModelValidations

  # check whether any features have been disabled and delete any relevant custom tiles
  def update_custom_tiles
    changed = []

    { "area_guide" => house_search_changed? && !house_search?,
      "services" => enable_services_changed? && !enable_services?,
      "home_designer" => enable_roomsketcher_changed? && !enable_roomsketcher?,
      "referrals" => enable_referrals_changed? && !enable_referrals?,
      "perks" => enable_perks_changed? && !enable_perks? }.each do |name, disabled|
      changed << name if disabled
    end

    CustomTile.delete_disabled(changed, all_developments) unless changed.empty?
  end

  # rubocop:disable SkipsModelValidations
  def update_convayencing
    return unless conveyancing_changed?

    divisions.update_all(conveyancing: conveyancing,
                         wecomplete_sign_in: wecomplete_sign_in,
                         wecomplete_quote: wecomplete_quote)

    Development.where(id: all_developments.map(&:id)).update_all(conveyancing: conveyancing)
  end
  # rubocop:enable SkipsModelValidations
end
# rubocop:enable Metrics/ClassLength
