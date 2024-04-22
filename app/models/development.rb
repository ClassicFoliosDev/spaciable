# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength, Rails/HasManyOrHasOneDependent, Rails/InverseOf
class Development < ApplicationRecord
  include ConstructionEnum
  include ClientPlatformEnum
  include Unlatch::Interface
  acts_as_paranoid

  belongs_to :developer, optional: true
  has_one :crm, through: :developer
  belongs_to :division, optional: true

  include PgSearch
  multisearchable against: [:name], using: %i[tsearch trigram]

  def parent
    division || developer
  end

  delegate :unlatch_developer, to: :parent

  def parent_developer
    developer || division.developer
  end

  delegate :company_name, to: :parent_developer

  def library
    lib = parent.library
    lib << documents
  end

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
  has_many :videos, as: :videoable
  has_many :development_messages
  has_many :choice_configurations, dependent: :destroy
  has_many :plot_documents, through: :plots, source: :documents
  has_one :maintenance, dependent: :destroy
  has_many :spotlights, -> { order(:sequence_no) }, dependent: :destroy

  has_many :event_resources, as: :resourceable, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  has_one :program, class_name: "Unlatch::Program", dependent: :destroy

  has_one :premium_perk
  accepts_nested_attributes_for :premium_perk
  delegate :enable_premium_perks, :premium_licences_bought,
           :premium_licence_duration, to: :premium_perk, allow_nil: true
  delegate :sign_up_count, to: :premium_perk, prefix: true
  delegate :branded_perk, :on_package, to: :parent_developer
  delegate :custom_url, to: :developer
  delegate :timeline, :time_zone, :proformas, to: :parent_developer
  delegate :wecomplete_sign_in, :wecomplete_quote, to: :parent

  alias_attribute :development_name, :name

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :maintenance, reject_if: :maintenance_blank?, allow_destroy: true

  scope :by_developer_and_developer_divisions, lambda { |developer_id|
    division_ids = Division.where(developer_id: developer_id).pluck(:id)

    where(developer_id: developer_id).or(where(division_id: division_ids))
  }

  validates :name, presence: true, uniqueness: { scope: %i[developer_id division_id] }
  validate :permissable_id_presence

  validates :construction_name, presence: true, if: :commercial?
  after_validation :set_business, on: [:update]

  delegate :building_name, :road_name, :locality,
           :city, :county, :postcode, to: :address, allow_nil: true
  delegate :to_s, to: :name
  delegate :development_faqs, :country, to: :parent

  delegate :house_search, :enable_referrals, :enable_services,
           :enable_roomsketcher, :enable_perks, to: :parent_developer

  delegate :path, :account_type, :populate, to: :maintenance, prefix: true, allow_nil: true

  delegate :build_steps, to: :parent

  after_destroy { User.permissable_destroy(self.class.to_s, id) }
  after_create :set_default_spotlights
  after_save :update_spotlights
  after_create :sync_with_unlatch

  alias_attribute :identity, :name

  enum choice_option:
    %i[
      choices_disabled
      admin_can_choose
      either_can_choose
    ]

  def programs
    program.blank? ? [] : [program]
  end

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

  def expired?
    expired = true
    # technical debt: a blank phase (all fields nil except development id) is created
    # when a development is created, have so far not been able to find where this creation
    # is happening and the record is not saved to database
    # for expiry to work for development we need to filter out the nil phase for each development
    live_phases = phases.where.not(id: nil)
    return expired = false if live_phases.empty?

    live_phases.each do |phase|
      return expired = false unless phase.expired?
    end
  end

  def partially_expired?
    plot_list = []
    plots.each do |plot|
      plot_list << plot if plot.expired?
    end
    return true if plot_list.count.positive?
  end

  # Are choices available for the user and plot.  If they are a resident then they must
  # be a homeowner.  If admin, then as long as they are not a site admin
  def choices?(current_user, plot)
    return false if choices_disabled?

    if current_user.is_a?(Resident) && current_user.plot_residency_homeowner?(plot)
      either_can_choose?
    elsif current_user.is_a? User
      ((admin_can_choose? || either_can_choose?) && !current_user.site_admin?)
    else
      false
    end
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

  def maintenance_blank?(maintenance)
    return false if maintenance["path"].present?

    record = Maintenance.find_by(development_id: id)
    record&.destroy!
    true
  end

  # document sync operations need a path to the relevant controller
  # for 'self' development.  Developments have either a developer or
  # division centric controller depending on their parent
  def sync_docs_path
    [:sync_docs, parent, self]
  end

  # get the docs from the crm
  def sync_docs
    raise "#{name} does not have an associated CRM" unless crm

    "Crms::#{crm.name}".classify.constantize.new(self).documents
  end

  # get the docs from the crm
  def download_doc(params)
    raise "#{name} does not have an associated CRM" unless crm

    "Crms::#{crm.name}".classify.constantize.new(self).download_doc(params)
  end

  # update existing phases business if development is updated to be commercial
  def set_business
    return unless commercial?

    phases.each do |phase|
      phase.update(business: :commercial)
    end
  end

  # Build the specified attribute if it is not already done
  def build
    build_address unless address
    build_maintenance unless maintenance
    build_premium_perk unless premium_perk
  end

  def descendants
    [phases, plots].flatten!
  end

  # Create up to three default spotlights
  def set_default_spotlights
    %w[services perks referrals].each do |tile|
      next unless parent_developer.send("enable_#{tile}")

      spotlight = Spotlight.create(development_id: id,
                                   editable: !%w[services perks].include?(tile))
      CustomTile.create(spotlight: spotlight, feature: tile)
    end
  end

  # check whether any features have been disabled and delete any relevant custom tiles
  # rubocop:disable Metrics/LineLength
  def update_spotlights
    changed = []

    { "issues" => !Maintenance.exists?(development_id: id),
      "snagging" => saved_change_to_enable_snagging? && !enable_snagging? }.each do |name, disabled|
      changed << name if disabled
    end

    Spotlight.delete_disabled(changed, self) unless changed.empty?
  end
  # rubocop:enable Metrics/LineLength

  # Find a matching Unlatch::Program if necessary
  def sync_with_unlatch
    return if unlatch_developer.blank?

    return if program.present?

    Unlatch::Program.add(unlatch_developer, self)
  end

  # Unlatch::Interface implementation
  def paired_with_unlatch?
    !program.nil?
  end

  def unlatch_deep_sync
    return unless linked_to_unlatch?

    sync_with_unlatch
    sync_docs_with_unlatch
    phases.each(&:unlatch_deep_sync)
    unit_types.each(&:unlatch_deep_sync)
  end

  # rubocop:disable Rails/Presence
  def my_construction_name
    construction_name.blank? ? I18n.t("homeowners.home") : construction_name
  end
  # rubocop:enable Rails/Presence

  def faq_types
    faq_types = FaqType.for_country(parent.country).to_a
    if commercial?
      faq_types.delete_if { |t| t.construction_type.residential? }
    else
      faq_types.delete_if { |t| t.construction_type.commercial? }
    end
    faq_types
  end

  # Retrieve relevant calendar events
  # rubocop:disable Metrics/AbcSize
  def events(params)
    # development events
    evts = Event.within_range(self.class.name, [id],
                              params[:start], params[:end]).to_a
    # add phases
    evts << Event.within_range(Phase.to_s, phases.map(&:id),
                               params[:start], params[:end]).to_a
    # add plots
    evts << Event.within_range(Plot.to_s, plots.map(&:id),
                               params[:start], params[:end]).to_a

    evts.flatten
  end
  # rubocop:enable Metrics/AbcSize

  def resources
    Plot.joins(phase: :development)
        .where(developments: { id: id })
        .where.not(phases: { package: Phase.packages[:free] })
        .order(:id).pluck(:id, :number)
  end

  def signature
    ""
  end

  def hierarchy
    ""
  end

  def conveyancing_enabled?
    conveyancing && parent.conveyancing_enabled?
  end

  def branding
    brand || parent&.brand || parent_developer&.brand
  end

  def all_phases_free?
    phases.count.positive? &&
      (phases.where(package: :free).count == phases.count)
  end
end
# rubocop:enable Metrics/ClassLength, Rails/HasManyOrHasOneDependent, Rails/InverseOf
