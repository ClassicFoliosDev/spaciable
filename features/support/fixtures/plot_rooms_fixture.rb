# frozen_string_literal: true
module PlotRoomsFixture
  module_function

  def setup
    CreateFixture.create_cf_admin
    CreateFixture.create_developer
    CreateFixture.create_development
    CreateFixture.create_unit_type
    CreateFixture.create_development_plot
    create_unit_type_rooms
  end

  UNIT_TYPE_ROOMS = [
    "Ultra Modern Bathroom",
    "Resturant Kitchen",
    "Saloon",
    "Greenhouse"
  ].freeze

  def unit_type_room_names
    UNIT_TYPE_ROOMS
  end

  def new_plot_room_name
    "Underwater Bedroom"
  end

  def updated_plot_room_name
    "Runner Duck Coop"
  end

  def template_room_to_update
    "Saloon"
  end

  def template_room_to_delete
    "Greenhouse"
  end

  def template_room_id_to_delete
    Room.find_by(name: template_room_to_delete).id
  end

  private

  module_function

  def create_unit_type_rooms
    UNIT_TYPE_ROOMS.each do |room_name|
      FactoryGirl.create(:room, name: room_name, unit_type: CreateFixture.unit_type)
    end
  end
end
