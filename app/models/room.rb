# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Room < ApplicationRecord
  acts_as_paranoid

  belongs_to :plot, optional: true
  belongs_to :unit_type, optional: true, inverse_of: :rooms
  belongs_to :development, optional: true
  belongs_to :division, optional: true
  belongs_to :developer, optional: false

  def parent
    plot || unit_type
  end
  include InheritParentPermissionIds
  include RoomEnum

  has_many :finish_rooms, inverse_of: :room
  has_many :finishes, through: :finish_rooms
  has_many :finish_manufacturers, through: :finishes

  has_many :appliance_rooms, inverse_of: :room
  has_many :appliances, through: :appliance_rooms
  has_many :appliance_manufacturers, through: :appliances
  has_many :appliance_categories, through: :appliances
  has_one :mark, as: :markable, dependent: :destroy

  delegate :marker, to: :mark, allow_nil: true
  delegate :cas, to: :developer

  amoeba do
    include_association :finish_rooms
    include_association :appliance_rooms
  end

  has_many :documents, as: :documentable, dependent: :destroy
  accepts_nested_attributes_for :documents, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :name, presence: true
  validates :name, uniqueness: { scope: %i[unit_type_id plot_id] }
  validates_associated :finish_rooms
  validates_associated :finishes
  validates_associated :appliance_rooms
  validates_associated :appliances

  delegate :completion_release_date, to: :plot
  delegate :restricted, to: :unit_type, prefix: true

  after_destroy -> { finishes.delete_all }
  after_save :update_mark

  alias_attribute :identity, :name

  before_create -> { @previous_rooms = current_rooms }
  after_create -> { log :created }
  before_update -> { @previous_rooms = current_rooms }
  after_update -> { log :updated if name_changed? }
  before_destroy -> { @previous_rooms = current_rooms }
  after_destroy -> { log :deleted }

  def cas?
    return false unless parent

    parent.cas
  end

  def build_finishes
    finishes.build if finishes.none?
  end

  def build_appliances
    appliances.build if appliances.none?
  end

  def appliances_count
    total = appliances.count
    if parent.is_a?(Plot) && parent.choices_approved?
      choices = Choice.joins(room_choices: { room_item: :room_configuration })
                      .where("room_choices.plot_id = #{plot.id} AND " \
                                   "lower(room_configurations.name) = '#{name.downcase}' AND " \
                                   "choices.choiceable_type = '" + "Appliance" + "'").count

      total += choices
    end
    total
  end

  def finishes_count
    total = finishes.count
    if parent.is_a?(Plot) && parent.choices_approved?
      choices = Choice.joins(room_choices: { room_item: :room_configuration })
                      .where("room_choices.plot_id = #{plot.id} AND " \
                                   "lower(room_configurations.name) = '#{name.downcase}' AND " \
                                   "choices.choiceable_type = '" + "Finish" + "'").count

      total += choices
    end
    total
  end

  def to_s
    name
  end

  def expired?
    false
  end

  def self.last_edited_by(room, user)
    room = Room.find(room)
    room.update_mark(user)
    room.save!
  end

  # log an update to the finishes/appliances
  def furnish_log(furnish, action)
    return unless cas?
    return PlotLog.furnish_update(self, furnish, action) if plot
    UnitTypeLog.furnish_update(self, furnish, action)
  end

  def update_mark(user = RequestStore.store[:current_user])
    mark&.destroy!
    create_mark(username: user.full_name, role: user.role)
  end

  private

  # log the room update
  def log(action)
    return unless cas?
    return PlotLog.process_rooms(plot, @previous_rooms, current_rooms) if plot
    UnitTypeLog.room_update(self, action)
  end

  # Get the current rooms against the plot/unit type
  def current_rooms
    return nil unless plot

    plot ? plot.rooms.to_a : unit_type.rooms.to_a
  end
end
# rubocop:enable Metrics/ClassLength
