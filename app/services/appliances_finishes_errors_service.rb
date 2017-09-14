# frozen_string_literal: false
module AppliancesFinishesErrorsService
  module_function

  def unit_type_errors(unit_type)
    errors = ""

    unit_type.rooms.each do |room|
      errors << room_errors(room)
    end

    errors
  end

  def room_errors(room)
    errors = ""

    room.appliance_rooms.each do |appliance_room|
      appliance_room.errors.messages[:appliance].each do |message|
        errors += " #{room} Appliance #{appliance_room.appliance_id} #{message}"
      end
    end
    room.finish_rooms.each do |finish_room|
      finish_room.errors.messages[:finish].each do |message|
        errors += " #{room} Finish #{finish_room.finish_id} #{message}"
      end
    end

    errors
  end
end
