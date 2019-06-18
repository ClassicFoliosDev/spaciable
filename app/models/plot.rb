# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Plot < ApplicationRecord
  acts_as_paranoid
  require "csv"

  attr_accessor :copy_plot_numbers

  DUMMY_PLOT_NAME = "ZZZ_DUMMY_PLOT_QQQ"

  belongs_to :phase, optional: true
  belongs_to :development, optional: false
  delegate :business, to: :development, prefix: true
  def parent
    phase || development
  end
  include InheritParentPermissionIds

  belongs_to :unit_type, optional: true
  belongs_to :developer, optional: false
  belongs_to :division, optional: true

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

  attr_accessor :notify

  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

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
  delegate :maintenance_link, to: :development, allow_nil: true
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

  enum progress: %i[
    soon
    in_progress
    roof_on
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
    return false if maintenance_link.blank?
    return true if expiry_date.blank?

    Time.zone.today < expiry_date
  end

  def to_s
    I18n.t(".plot", number: number)
  end

  def activated_resident_count
    residents.where.not(invitation_accepted_at: nil).count
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

  # Export the choices for this plot as CSV data
  def export_choices
    attributes = %w[room name full_name]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      room_choices.each do |choice|
        csv << attributes.map { |attr| choice.send(attr) }
      end
    end
  end

  def referrer_address
    if division.present?
      "#{division}, #{development}, #{phase}"
    else
      "#{development}, #{phase}"
    end
  end

  # rubocop:enable Metrics/ClassLength

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

  # Get the matching room configuration for the plot
  def room_configuration(room)
    choice_configuration&.room_configurations
                        &.where("lower(name) = ?", room.name.downcase)
                        &.first
  end
end
