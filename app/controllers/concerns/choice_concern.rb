# frozen_string_literal: true

module ChoiceConcern
  extend ActiveSupport::Concern

  def build_full_choices
    build_choices(true)
  end

  def build_short_choices
    build_choices(false)
  end

  # Build the item choices for each room of the plot.  The item choices will be listed against
  # the room on the form.  The plot will have a choice_configuration, and the choice_configuration
  # has rooms_configurations.  The room_configuration are matched against the names of the plot's
  # rooms.  Each room/room item combination creates a 'hash' id that is assigned to the html
  # element that displays the item choices name.  This allows the javascript to fill in the choices
  # when the user makes selections.
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def build_choices(full_names)
    @choices = []
    @rooms = []
    @full_house = 0
    @room_item_choices = {}
    @plot.rooms.each do |room|
      room_config = @plot&.room_configuration(room)

      room_items = []
      if room_config.present?
        room_config.room_items.each do |room_item|
          choice = room_choice(room_item)
          @room_item_choices[room_item.id] = choice.id if choice.present?
          room_items << { name: room_item.name, id: "#{room.id}_#{room_item.id}",
                          choice: choice&.name(full_names), archived: choice&.archived }
        end
      end

      next if room_items.empty?

      @full_house += room_items.length # the total number of choise options
      @choices << { id: room.id, name: room.name, icon_name: room.icon_name,
                    items: room_items }
      @rooms << { id: room.id, name: room.name }
    end
  end
  # rubocop:enable Metrics/MethodLength,  Metrics/AbcSize

  def room_choice(room_item)
    Choice.joins(:room_choices)
          .find_by(room_choices:
                    {
                      plot_id: @plot.id,
                      room_item_id: room_item.id
                    })
  end
end
