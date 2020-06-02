# frozen_string_literal: true

class PlotLog < Log
  class << self
    # The rooms displayed against a plot are not straight forward as they
    # are a combination of unit type and plot specifics.  Comparing the
    # associated rooms before and after a create/update/delete calculates
    # the changes that will appear to the use on screen
    def process_rooms(plot, before, after)
      # find the updated rooms
      updated = []
      before.each do |room_before|
        room = after.find { |r| r.id == room_before.id }
        next if room.nil? || room.name == room_before.name

        # remove the rooms so they don't affect the
        # created and deleted calculations that follow
        before.delete(room_before)
        after.delete(room)
        updated << room
      end
      add plot, updated, :updated

      add plot, (after - before), :created
      add plot, (before - after), :deleted
    end

    # Report a change of finish/appliance
    def furnish_update(room, furnish, action)
      log(logable_type: Plot,
          logable_id: room.plot.id,
          primary: "#{room} (Plot)",
          secondary: "#{furnish.class}: #{furnish}",
          action: action)
    end

    # log a change of unit type
    def unit_type_update(plot)
      log(logable_type: Plot,
          logable_id: plot.id,
          secondary: "Unit Type: #{plot.unit_type}",
          action: Log.actions[:updated])
    end

    # A room on a unit type has changed.  Log an entry for all
    # plots associated with the unit type
    def unit_type_room_update(room, action)
      plots = Plot.where(unit_type_id: room.unit_type.id)
      plots.each { |plot| add(plot, [room], action) }
    end

    private

    # Add a log entry
    def add(plot, rooms, action)
      rooms.each do |room|
        log(logable_type: Plot,
            logable_id: plot.id,
            primary: "#{room} #{room.plot ? '(Plot)' : '(Unit Type)'}",
            action: action)
      end
    end
  end
end
