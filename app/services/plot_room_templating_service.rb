# frozen_string_literal: true

class PlotRoomTemplatingService
  def initialize(plot)
    @plot = plot
  end
  attr_reader :plot

  def self.template_room?(room)
    room.plot_id.blank?
  end
  delegate :template_room?, to: :class

  def build_room(room_scope: nil, template_room_id: nil)
    room = plot.plot_rooms.build

    if template_room_id.present?
      room.assign_attributes template_attributes(template_room_id, room_scope)
    end

    room
  end

  def self.clone_room(plot_id, old_room)
    return if plot_id.nil?

    plot = Plot.find(plot_id)

    # Don't continue if the room parent is already the plot
    return if old_room.parent == plot

    # Tidy up any unsaved content in the old room
    old_room.reload

    # Clone the room, and connect it with the plot instead of the unit type
    new_room = old_room.amoeba_dup
    new_room.unit_type_id = nil
    new_room.plot_id = plot.id
    new_room.template_room_id = old_room.id

    new_room.save!
    new_room
  end

  def destroy(room)
    if template_room?(room)
      create_deleted_plot_room(template_room_id: room.id)
    else
      room.destroy
    end
  end

  private

  def template_attributes(template_room_id, room_scope)
    attributes = room_scope.find(template_room_id).attributes

    attributes.symbolize_keys!
    attributes.delete(:unit_type_id)

    { **attributes, plot_id: plot.id, template_room_id: template_room_id }
  end

  # Scenario:
  # - there is a unit type room
  # - the user wants to remove that room from a single plot
  # - this should not delete the unit type room, so that other plots still show the room
  #
  # By creating a deleted plot room, with the `template_room_id` of the unit type room, the
  # plot will exclude this unit type room from its list of rooms
  def create_deleted_plot_room(template_room_id:)
    plot_room = plot.plot_rooms.build(
      template_room_id: template_room_id,
      deleted_at: Time.zone.now
    )

    plot_room.save(validate: false)
    plot_room
  end
end
