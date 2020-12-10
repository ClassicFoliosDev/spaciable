# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Plot < ApplicationRecord
  acts_as_paranoid
  require "csv"

  attr_accessor :copy_plot_numbers

  DUMMY_PLOT_NAME = "ZZZ_DUMMY_PLOT_QQQ"
  DASHBOARD_TILES = 5 # total number of customisable tiles on the homeowner dashboard

  belongs_to :phase, optional: true
  belongs_to :development, optional: false
  def parent
    phase || development
  end
  include InheritParentPermissionIds

  belongs_to :unit_type, optional: true
  belongs_to :developer, optional: false
  has_one :crm, through: :developer
  belongs_to :division, optional: true
  has_one :plot_timeline, dependent: :destroy
  accepts_nested_attributes_for :plot_timeline, reject_if: :all_blank, allow_destroy: true

  delegate :timeline_title, to: :plot_timeline, allow_nil: true

  belongs_to :choice_configuration
  has_many :room_choices, dependent: :destroy

  has_many :room_choices, dependent: :destroy
  has_many :plot_residencies, dependent: :destroy
  has_many :plot_private_documents, dependent: :destroy
  has_many :private_documents, through: :plot_private_documents
  has_many :plot_documents, dependent: :destroy
  has_many :documents, through: :plot_documents
  has_many :residents, through: :plot_residencies

  has_many :unit_types, through: :development
  has_many :plot_rooms, class_name: "Room"
  has_many :finishes, through: :rooms
  has_many :documents, as: :documentable
  has_many :snags, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  has_one :listing, dependent: :destroy

  delegate :other_ref, to: :listing, prefix: true
  delegate :cas, to: :development
  delegate :time_zone, to: :developer
  delegate :calendar, to: :development, prefix: true
  delegate :construction, to: :development
  delegate :custom_url, to: :developer

  alias_attribute :identity, :number

  attr_accessor :notify

  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  validates :uprn, length: { maximum: 12,
                             too_long: I18n.t("plots.plot.uprn_error") }
  validates :uprn, format: { with: /\A\d*\z/,
                             message: I18n.t("plots.plot.uprn_error") }

  validates :number, presence: true
  validates :unit_type, presence: true
  validates :validity, :extended_access, numericality: {
    greater_than_or_equal_to: 0, only_integer: true
  }
  validates_with PlotCombinationValidator

  delegate :picture, to: :unit_type, prefix: true
  delegate :external_link, to: :unit_type
  delegate :branded_logo, to: :brand, allow_nil: true
  delegate :branded_email_logo, to: :brand, allow_nil: true
  delegate :house_search, :enable_services?, :enable_roomsketcher?, to: :developer, allow_nil: true
  delegate :enable_referrals?, to: :developer, allow_nil: true
  delegate :enable_development_messages?, to: :developer
  delegate :enable_snagging, to: :development, allow_nil: true
  delegate :snag_name, to: :development
  delegate :company_name, to: :developer
  delegate :division_name, to: :division
  delegate :name, to: :development, prefix: true
  delegate :name, to: :phase, prefix: true
  delegate :choices_email_contact, to: :development
  delegate :business, to: :phase
  delegate :list_id, to: :developer
  delegate :construction, :construction_name, to: :development, allow_nil: true

  delegate :enable_perks?, :perks_branded_link, :branded_perk, to: :developer
  delegate :enable_premium_perks, :premium_licence_duration, to: :development
  delegate :premium_licences_bought, to: :development, prefix: true

  delegate :maintenance, to: :development, allow_nil: true

  delegate :custom_tiles, to: :development

  after_create :post_create
  after_update :post_update
  after_save :check_completion

  # Retrieve all plots for the phase that are allocated to a timeline
  scope :on_phase_timeline,
        lambda { |phase_timeline|
          joins(plot_timeline: :phase_timeline)
            .where(phase_timelines: { id: phase_timeline.id }).order(:id)
        }

  # Retrieve all plots for the phase that are NOT allocated to a timeline
  scope :timeline_free,
        lambda { |phase|
          left_outer_joins(:plot_timeline)
            .where(phase_id: phase.id, plot_timelines: { plot_id: nil }).order(:id)
        }

  enum progress: %i[
    soon
    in_progress
    roof_on
    first_fix
    second_fix
    kitchen
    sanitaryware
    decoration
    tiling
    flooring
    driveway
    landscaping
    exchange_ready
    complete_ready
    completed
    remove
  ]

  enum choice_selection_status: %i[
    no_choices_made
    homeowner_updating
    admin_updating

    committed_by_homeowner
    choices_approved
    choices_rejected
  ]

  def rooms(room_scope = Room.all)
    templated_room_ids = plot_rooms.with_deleted.pluck(:template_room_id).compact
    unit_type_rooms_relation = room_scope
                               .where(unit_type_id: unit_type_id)
                               .where.not(id: templated_room_ids)

    room_scope.where(plot_id: id).or(unit_type_rooms_relation)
  end

  # ADDRESSES

  delegate :address, to: :parent, prefix: :parent, allow_nil: true
  delegate :locality, :city, :county, to: :parent, allow_nil: true
  delegate :api_key, to: :developer, allow_nil: true

  def building_name
    if address&.building_name?
      address.building_name
    else
      parent.building_name
    end
  end

  def road_name
    if address&.road_name?
      address.road_name
    else
      parent.road_name
    end
  end

  def postal_number
    return house_number if house_number.present?

    if address&.postal_number?
      address.postal_number
    else
      parent.address&.postal_number
    end
  end

  def postcode
    if address&.postcode?
      address.postcode
    else
      parent.postcode
    end
  end

  def timeline
    plot_timeline&.timeline_id
  end

  def prefix
    address.prefix if address&.prefix?
  end

  def prefix=(name)
    return if parent_address && name.present? && name == parent_address.building_name

    (address || build_address).prefix = name
  end

  def building_name=(name)
    return if parent_address && name.present? && name == parent_address.building_name

    (address || build_address).building_name = name
  end

  def road_name=(name)
    return if parent_address && name.present? && name == parent_address.road_name

    (address || build_address).road_name = name
  end

  def locality=(_); end

  def city=(_); end

  def county=(_); end

  def postcode=(name)
    return if parent_address && name.present? && name == parent_address.postcode

    (address || build_address).postcode = name
  end

  # Temporary solution to allow allocation of a timeline to
  # a plot.  Phase 2 will replace
  def timeline=(timeline)
    if timeline.empty?
      plot_timeline&.destroy
    else
      pt = (plot_timeline || build_plot_timeline)
      pt.timeline_id = timeline
      pt.task_id = nil
      pt.complete = false
      pt&.task_logs&.destroy_all
    end
  end

  def number
    return if self[:number].blank?

    BulkPlots::Numbers.Number(self[:number])
  end

  def number=(int_or_float)
    self[:number] = BulkPlots::Numbers.Number(int_or_float)
  end

  def brand
    development&.brand || division&.brand || developer&.brand || Brand.new
  end

  def <=>(other)
    PlotCompareService.call(self, other)
  end

  def parent=(object)
    case object
    when Phase
      self.phase = object
      self.development = nil
    when Development
      self.phase = nil
      self.development = object
    end
  end

  def private_document_count
    residents.map { |resident| resident&.private_documents&.count.to_i }.sum
  end

  def expiry_date
    return if completion_release_date.blank?
    return completion_release_date + validity.months if extended_access.blank?

    completion_release_date + validity.months + extended_access.months
  end

  def reduced_expiry_date
    return if completion_release_date.blank?

    completion_release_date + validity.months
  end

  def expired?
    return if completion_release_date.blank?

    Time.zone.today > expiry_date
  end

  def partially_expired?; end

  # Scheduled expiry emails
  def self.notify_expiry_plots
    expiry_plots = []
    reduced_expiry_plots = []
    Plot.find_each do |plot|
      expiry_plots << plot.id if plot.expiry_date == Time.zone.today - 1.day
      reduced_expiry_plots << plot.id if plot.reduced_expiry_date == Time.zone.today - 1.day &&
                                         plot.maintenance.path
    end

    ExpiryPlotsJob.perform_later(expiry_plots, reduced_expiry_plots)
  end

  # SNAGS

  # Checks whether the Snagging tab under 'My home' is valid/visible for the plot
  def snagging_valid
    after_completion_date && snag_link_valid
  end

  # If today's date is before snagging expiry date but after plot completion date,
  # or if today's date if after snagging expiry date but there are unresolved snags remaining,
  # then the snagging link is valid.
  def snag_link_valid
    return false if snagging_expiry_date.blank?

    snagging_expiry_date > Time.zone.today ||
      (snagging_expiry_date < Time.zone.today && unresolved_snags.positive?)
  end

  # Checks that the plot development has enabled snagging,
  # and that today's date is after or equal to plot completion date
  def after_completion_date
    development.enable_snagging? && completion_date <= Time.zone.today if completion_date
  end

  # Checks whether the current date is after plot snagging duration has ended
  # and there are no unresolved snags for the plot.
  def snags_fully_resolved
    development.enable_snagging? &&
      (snagging_expiry_date < Time.zone.today if completion_date?) && unresolved_snags.zero?
  end

  def snagging_days_remaining
    return unless snagging_expiry_date

    snags_fully_resolved ? "Closed" : (snagging_expiry_date - Time.zone.today).to_i
  end

  def snagging_expiry_date
    return if completion_date.blank?

    return if development.snag_duration < 1

    completion_date + development.snag_duration.days
  end

  def show_maintenance?
    return false if !maintenance&.path? || completion_release_date.nil?
    return true if reduced_expiry_date.blank?

    Time.zone.today <= reduced_expiry_date
  end

  def to_s
    I18n.t(".plot", number: number)
  end

  def activated_resident_count
    residents.where.not(invitation_accepted_at: nil).size
  end

  def to_homeowner_s
    if postal_number.present?
      if building_name.present?
        "#{prefix} #{postal_number} #{building_name}".strip
      else
        "#{prefix} #{postal_number} #{road_name}".strip
      end
    elsif building_name.present?
      "#{building_name} (#{self})"
    else
      "#{road_name} (#{self})".strip
    end
  end

  # Are choices available to this user for this plot
  def choices?(current_user)
    choice_configuration_id.present? && development.choices?(current_user, self)
  end

  def referrer_address
    if division.present?
      "#{division}, #{development}, #{phase}"
    else
      "#{development}, #{phase}"
    end
  end

  # Is the plot Spanish
  # rubocop:disable all
  def spanish?
    (parent.is_a?(Developer) && parent.country.spain?) ||
    (parent.is_a?(Phase) && parent.developer.country.spain?)
  end
  # rubocop:enable all

  # Generate the list of admins that will receive choice selections
  def choice_admins
    User.choice_enabled_admins_associated_with([developer, division, development])
  end

  # Generate a list of homeowners for the plot
  def homeowners
    residents.to_a.select { |resident| resident.plot_residency_homeowner?(self) }
  end

  # Get the approvd applicance choices made for the plot
  def appliance_choices
    return unless choices_approved?

    choices = Choice.joins(:room_choices)
                    .where(choices: { choiceable_type: "Appliance" },
                           room_choices: { plot_id: id }).to_a
    choices&.map(&:choiceable)
  end

  # Get the approvd applicance choices made for the plot
  def finish_choices
    return unless choices_approved?

    choices = Choice.joins(:room_choices)
                    .where(choices: { choiceable_type: "Finish" },
                           room_choices: { plot_id: id }).to_a
    choices&.map(&:choiceable)
  end

  # Get the matching room configuration for the plot
  def room_configuration(room)
    choice_configuration&.room_configurations
                        &.where("lower(name) = ?", room.name.downcase)
                        &.first
  end

  def finishes_count
    finishes = 0
    rooms.each do |room|
      finishes += room.finishes.count
    end
    finishes += finish_choices.count if finish_choices
    finishes
  end

  def appliances_count
    appliances = 0
    rooms.each do |room|
      appliances += room.appliances.count
    end
    appliances += appliance_choices.count if appliance_choices
    appliances
  end

  def all_snags_count
    snags.count
  end

  def resolved_snags_count
    snags.where(status: "approved").count
  end

  # Does the plot have a listing
  def listing?
    listing.present?
  end

  # How many rooms of the provided type does this plot have?
  def rooms?(key)
    rooms&.select { |r| r.icon_name == Room.icon_names.key(key.to_i) }&.count
  end

  def completed?
    return false unless completion_date

    Time.zone.today >= completion_date
  end

  def my_home_name
    I18n.t("homeowners.my_home_name", construction: my_construction_name)
  end

  def my_construction_name
    construction_name.presence ? construction_name : I18n.t("homeowners.home")
  end

  def post_create
    # log the initial set of rooms for the plot
    return unless cas

    PlotLog.process_rooms(self, [], rooms.to_a)
  end

  # perform post update logging
  def post_update
    return unless unit_type_id_changed?
    return unless cas

    old_rooms = UnitType.find(unit_type_id_was).rooms.to_a
    PlotLog.process_rooms(self, old_rooms, rooms.to_a)
    PlotLog.unit_type_update(self)
  end

  # perform post completion initialisation
  def check_completion
    return unless developer.cas
    return if completion_release_date.blank?
    return unless unit_type_id_changed? || completion_release_date_changed?

    Cas::Finishes.initalise_plots([self])
  end

  def log_threshold
    return :none if RequestStore.store[:current_user].cf_admin?

    completion_release_date.nil? ? Time.zone.now : completion_release_date
  end

  def hide_logs?
    return true unless cas
    return false if RequestStore.store[:current_user].cf_admin?

    completion_release_date.blank? || completion_release_date > Time.zone.today
  end

  # get the doc from the crm
  def download_doc(params)
    raise "#{name} does not have an associated CRM" unless crm

    "Crms::#{crm.name}".classify.constantize.new(self).download_doc(params)
  end

  # update the supplied plots with the new Completion Dates
  def self.update_cds(plots)
    Plot.transaction do
      begin
        plots.each do |p|
          Plot.find(p.id.to_i)
              .update_attributes(completion_date: p.completion_date.to_date)
        end
        updates = plots.count
      rescue ActiveRecord::RecordInvalid => e
        error = e.message
        raise ActiveRecord::Rollback
      end

      yield updates, error
    end
  end

  def emails
    residents.map(&:email)
  end

  # Retrieve relevant calendar events
  # rubocop:disable Metrics/AbcSize
  def events(params)
    # parent development events
    evts = Event.resources_within_range(
      Development.to_s, [development.id], self.class.to_s, [id],
      params[:start], params[:end]
    ).to_a
    # Phase
    evts << Event.resources_within_range(
      Phase.to_s, [phase.id], self.class.to_s, [id],
      params[:start], params[:end]
    ).to_a
    # add plots
    evts << Event.within_range(self.class.to_s, [id],
                               params[:start], params[:end]).to_a

    evts.flatten
  end
  # rubocop:enable Metrics/AbcSize

  # Retrieve relevant resident calendar events.  Remember that
  # a resident may have events on many different plots
  # rubocop:disable Metrics/AbcSize
  def self.resident_events(resident, params)
    # parent development events
    evts = Event.for_resource_within_range(
      Development.to_s, name, resident.plots.pluck(:id),
      params[:start], params[:end]
    ).to_a
    # Phase
    evts << Event.for_resource_within_range(
      Phase.to_s, name, resident.plots.pluck(:id),
      params[:start], params[:end]
    ).to_a
    # add plots
    evts << Event.for_resource_within_range(
      name, resident.class.to_s, [resident.id],
      params[:start], params[:end]
    ).to_a

    evts.flatten
  end
  # rubocop:enable Metrics/AbcSize

  def resources
    residents.map { |r| [r.id, r.to_s] }
  end

  # rubocop:disable Metrics/AbcSize
  def signature(admin = true)
    compnt = ""

    if admin
      compnt = "#{phase.name}: "
    elsif road_name.blank? && building_name.blank?
      compnt = "#{development.identity}: "
    end

    compnt +
      (prefix.blank? ? "" : "#{prefix} ") +
      (postal_number.blank? ? "" : "#{postal_number} ") +
      (building_name.blank? ? "" : "#{building_name} ") +
      (road_name.blank? ? "" : road_name)
  end
  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Metrics/ClassLength
