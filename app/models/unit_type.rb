# frozen_string_literal: true

class UnitType < ApplicationRecord
  acts_as_paranoid
  belongs_to :development, optional: false
  alias parent development
  include InheritParentPermissionIds
  mount_uploader :picture, PictureUploader

  belongs_to :developer, optional: false
  belongs_to :division, optional: true

  has_many :rooms, dependent: :destroy, inverse_of: :unit_type
  has_many :plots, dependent: :destroy
  has_many :phases_unit_types
  has_many :phases, through: :phases_unit_types
  has_many :documents, as: :documentable, dependent: :destroy
  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true

  delegate :cas, to: :development
  delegate :construction, :construction_name, to: :development, allow_nil: true

  amoeba do
    include_association :rooms
  end

  enum build_type: %i[
    apartment
    coach_house
    house_detached
    house_semi
    house_terraced
    maisonette
    penthouse
    studio
  ]

  after_create -> { UnitTypeLog.create(self) if cas }

  # Unit type update options
  UNCHANGED = 0
  RESET = 1
  SUPPLEMENT = 2

  validates :name, presence: true, uniqueness: { scope: :development_id }

  def to_s
    name
  end

  def self.rebuild_pg_search_documents
    find_each do |record|
      record.update_pg_search_document unless record.deleted?
    end
  end

  # All the plots using this unit_type grouped by phase.  The function
  # returns a hash of {phase_name , [phase plots]}
  def plots_by_phase
    plots = Plot.joins(:phase)
                .select("phases.name", :number)
                .where(unit_type_id: id)
                .group("phases.name", :number)
                .pluck(:name, :number)

    plots.group_by(&:first).map { |p, n| [p, n.map(&:last)] }.to_h
  end

  # Returns a confirmation message detailing the list of plots effected
  # by the deletion of the unit_type.
  def delete_confirmation
    confirmation = "Are you sure you wish to delete the <b>#{name}</b> unit type?"

    effected_phases = plots_by_phase
    if effected_phases.present?
      confirmation = " This unit type cannot be deleted because it is in use. " \
                      "Please reassign the following plots to other unit types " \
                      "before deleting"
      effected_phases.each do |phase, plots|
        confirmation += "<br><br>#{phase}: #{plots.to_sentence}"
      end
    end

    confirmation
  end

  def expired?
    return false if plots.empty?

    plots.all?(&:expired?)
  end

  def partially_expired?
    plot_list = []
    plots.each do |plot|
      plot_list << plot if plot.expired?
    end
    return true if plot_list.count.positive?
  end

  def picture_name
    name = picture.to_s
    name = name.split("/")
    name = name.last.split(".")
    # splits the file name at the ".", and takes the first three characters of the extension
    name.first + "." + name.last.split("?").first
  end

  def finishes_count
    finishes = 0
    rooms.each do |room|
      finishes += room.finishes.count
    end
    finishes
  end

  def appliances_count
    appliances = 0
    rooms.each do |room|
      appliances += room.appliances.count
    end
    appliances
  end

  # This function has to exist to satisfy the generic requirement of all
  # classes that produce logs.  If we want to restrict the logs displayed
  # to different users then we would do it here
  def log_threshold
    :none
  end
end
