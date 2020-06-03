# frozen_string_literal: true

class UnitTypeLog < Log
  class << self
    def create(unit_type)
      log(logable_type: UnitType,
          logable_id: unit_type.id,
          secondary: "Unit Type: #{unit_type.name}",
          action: :created)
    end

    def room_update(room, action)
      log(logable_type: UnitType,
          logable_id: room.unit_type.id,
          primary: room.name,
          action: action)

      # log for all effected plots
      PlotLog.unit_type_room_update(room, action)
    end

    def furnish_update(room, furnish, action)
      log(logable_type: UnitType,
          logable_id: room.unit_type.id,
          primary: room,
          secondary: "#{furnish.class}: #{furnish}",
          action: action)
    end
  end
end
