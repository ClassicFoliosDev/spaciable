# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Phase < ApplicationRecord
  attribute :number, :integer

  acts_as_paranoid

  include PgSearch
  multisearchable against: [:name], using: %i[tsearch trigram]

  belongs_to :development, optional: false, counter_cache: true
  delegate :name, to: :development, prefix: true
  alias parent development
  include InheritParentPermissionIds

  belongs_to :developer, optional: false
  has_one :crm, through: :developer
  delegate :company_name, to: :developer
  belongs_to :division, optional: true
  delegate :division_name, to: :division
  delegate :cas, to: :development
  delegate :name, to: :development, prefix: true

  has_many :plots, dependent: :destroy
  has_many :plot_residencies, through: :plots
  has_many :residents, through: :plot_residencies
  has_many :plot_documents, through: :plots, source: :documents
  has_many :phase_timelines, dependent: :destroy
  has_one :brand, as: :brandable, dependent: :destroy
  has_many :brands, as: :brandable

  has_many :event_resources, as: :resourceable, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy

  delegate :enable_snagging, to: :development
  delegate :construction, :construction_name, to: :development, allow_nil: true
  delegate :calendar, to: :development, prefix: true
  delegate :time_zone, to: :developer
  delegate :wecomplete_sign_in, :wecomplete_quote, to: :parent

  delegate :timeline, to: :developer

  has_many :contacts, as: :contactable, dependent: :destroy

  has_many :unit_types, through: :development
  has_many :documents, as: :documentable
  has_one :address, as: :addressable, dependent: :destroy

  alias_attribute :identity, :name

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  attr_accessor :notify

  scope :by_developer_and_developer_divisions, lambda { |developer_id|
    division_ids = Division.where(developer_id: developer_id).pluck(:id)

    where(developer_id: developer_id).or(where(division_id: division_ids))
  }

  before_validation :set_number

  validates :name, :number, presence: true, uniqueness: { scope: :development_id }
  validates :number,
            uniqueness: { scope: :development_id }

  delegate :building_name, :road_name, :locality, :city,
           :county, :postcode, to: :address, allow_nil: true
  delegate :to_s, to: :name

  delegate :build_steps, to: :parent

  enum business: [
    :core, # default
    :nhbc,
    :mhf,
    :commercial
  ]

  enum package: %i[
    free
    essentials
    professional
    legacy
  ]

  validates :package, presence: true

  def res_comp?
    plots.where("plots.completion_release_date IS NOT NULL OR " \
                "plots.reservation_release_date IS NOT NULL")
         .count.positive?
  end

  def build_address_with_defaults
    return if address.present?
    return build_address if !development || !development.address

    address_fields = %i[postal_number building_name road_name
                        locality city county postcode]
    address_attributes = development.address.attributes.select do |key, _|
      address_fields.include?(key.to_sym)
    end

    build_address(address_attributes)
  end

  def set_number
    return self[:number] if self[:number].present?
    return self[:number] = 1 unless development

    self[:number] = development.phases.count + 1
  end

  def number
    self[:number] || set_number
  end

  def expired?
    expired = true
    return expired = false if plots.empty?

    plots.each do |plot|
      return expired = false unless plot.expired?
    end
  end

  def partially_expired?
    plots_list = []
    plots.each do |plot|
      plots_list << plot if plot.expired?
    end
    return true if plots_list.count.positive?
  end

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end

  # Generate the list of emails that will receive the snag notifications
  def snag_users
    User.users_associated_snags([developer, division, development])
  end

  # Generate the list of emails that currently will receive release plot updates
  def release_users
    User.users_associated_with([developer, division, development])
  end

  def self.snagging(current_ability)
    Phase.joins(:development)
         .where(developments: { enable_snagging: true })
         .where.not(package: %i[free essentials])
         .accessible_by(current_ability)
  end

  def active_plots_count
    active_count = 0
    plots.each do |plot|
      if !plot.expired? &&
         !(plot.completion_release_date.nil? && plot.reservation_release_date.nil?)
        active_count += 1
      end
    end
    active_count
  end

  def completed_plots_count
    plots.where.not(completion_release_date: nil).size
  end

  def expired_plots_count
    expired_count = 0
    plots.each do |plot|
      expired_count += 1 if plot.expired?
    end
    expired_count
  end

  def activated_resident_count
    activated_count = 0
    plots.each do |plot|
      if plot.reservation_release_date || plot.completion_release_date
        activated_count += plot.activated_resident_count
      end
    end
    activated_count
  end

  def released_resident_count
    released_count = 0
    plots.each do |plot|
      if plot.reservation_release_date || plot.completion_release_date
        released_count += plot.plot_residencies.size
      end
    end
    released_count
  end

  # get the phase plot docs from the crm
  def sync_docs(plot_numbers)
    raise "#{name} does not have an associated CRM" unless crm

    filtered_plots(plot_numbers) do |fplots|
      "Crms::#{crm.name}".classify.constantize.new(self)
                         .documents_for(development, fplots, :number)
    end
  end

  # get the phase plot docs from the crm
  def completion_dates(plot_numbers)
    raise "#{name} does not have an associated CRM" unless crm

    filtered_plots(plot_numbers) do |fplots|
      "Crms::#{crm.name}".classify.constantize.new(self).completion_dates(development, fplots)
    end
  end

  # get plot residents
  def plot_residents(plot_numbers)
    raise "#{name} does not have an associated CRM" unless crm

    filtered_plots(plot_numbers) do |fplots|
      "Crms::#{crm.name}".classify.constantize.new(self).residents(development, fplots)
    end
  end

  def filtered_plots(plot_numbers)
    yield plots.where(number: plot_numbers.split(","))
  end

  def descendants
    plots
  end

  # Retrieve relevant calendar events
  # rubocop:disable Metrics/AbcSize
  def events(params)
    return if free?
    # parent development events
    evts = Event.within_range(Development.to_s, [development.id],
                              params[:start], params[:end]).to_a
    # Phase
    evts << Event.within_range(self.class.to_s, [id],
                               params[:start], params[:end]).to_a
    # add plots
    evts << Event.within_range(Plot.to_s, plots.map(&:id),
                               params[:start], params[:end]).to_a

    evts.flatten
  end
  # rubocop:enable Metrics/AbcSize

  def resources
    plots.order(:id).map { |p| [p.id, p.number, p.comp_rel] }
  end

  def signature
    identity
  end

  def hierarchy
    "#{name}: "
  end

  def conveyancing_enabled?
    conveyancing && parent.conveyancing_enabled?
  end
end
# rubocop:enable Metrics/ClassLength
