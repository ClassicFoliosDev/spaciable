# frozen_string_literal: true

# rubocop:disable all
class Cas
  require 'csv'

  FINISHES = "#{Rails.root}/config/Finishes.csv"
  FINISH = "Finish"
  CATEGORY = "Category"
  TYPE = "Type"
  MANUFACTURER = "Manufacturer"

  class Finishes

    class << self

      # Initialse the static finishes from the Finishes.csv file, and the
      # finishes from all released plots for the developer.
      def initialise(developer_id)
        initialise_static(developer_id)
        initialise_dynamic(developer_id)
      end

      # Initialise the csv finishes
      def initialise_static(developer_id)
        CSV.parse(File.read(FINISHES), headers: true).each do |finish|
          Finish.find_or_create({name: finish[FINISH],
                                 category: finish[CATEGORY],
                                 type: finish[TYPE],
                                 manufacturer: finish[MANUFACTURER],
                                 developer_id: developer_id},
                                 [])
        end
      end

      # Create a local 'developer' copy of all finishes assigned to plots and unit types for the
      # developer.  All the finishes will be 'CF Admin' defined and not visible to the developer.
      # So new categories/types and manufactures will be created, then the room finishes will be
      # updated to the new 'developer' copies
      def initialise_dynamic(developer_id)
        # Get the set of all the finshes used by the developer - given this is a relational database you
        # would think that this could be achieved some nice joins .. but .. such is the implementation
        # of plot rooms -mixing UT and Plot rooms together using a scope (see rooms in Plot) then this
        # makes it next to impossible so we have to work through it.
        period = (Time.now.midnight - 100.years)..Time.now.midnight
        # Get all the released plots for the developer
        initalise_plots(Plot.where({ developer_id: developer_id, completion_release_date: period }))
      end

      # Go and calculate a hash of finishes against arrays of rooms that use them created on the fly.  This nonclementure
      # provides an initialisation pattern for entries with a non existant key.  When a non existant key
      # is specified then an empty array is automatically created against that key
      def initalise_plots(plots)
        return if plots.empty?
        developer_id = plots[0].developer_id
        raise StandardError.new \
              "Plots contains mixed developers" \
              unless plots.all? { |p| p.developer_id == developer_id }

        finishes = []
        # A hash of finishes against arrays of rooms that use them created on the fly.  This nonclementure
        # provides an initialisation pattern for entries with a non existant key.  When a non existant key
        # is specified then an empty array is automatically created against that key
        finish_rooms = Hash.new {|finish_id,room_id| finish_id[room_id] = []}

        # Go through the plots
        plots.each do |plot|
          # Get the rooms - this will use the Plot.room scope that does the trickery regarding which UT and
          # plot rooms are visible for the plot
          plot.rooms.each do |room|
            # If the room has a plot_id then it is a plot room and should be included.  If it is a UT room
            # then only include it if the UT is not restricted - ie uneditable to CAS admins
            if room.plot_id.present? || !room.unit_type_restricted
              # Go through the room finishes
              room.finishes.each do |finish|
                # ignore developer finishes
                next if finish.developer_id == developer_id
                finishes |= [finish] # add finish if unique
                finish_rooms[finish.id] << room.id # add the room against the finish
              end
            end
          end
        end

        # Go through each finish
        finishes.each do |finish|
          Finish.find_or_create({name: finish.name,
                                 category: finish.finish_category_name,
                                 type: finish.finish_type_name,
                                 manufacturer: finish&.finish_manufacturer_name,
                                 developer_id: developer_id},
                                 finish_rooms[finish.id]) # the rooms associated with the finish

          # finally delete all the finish rooms pointing at the CF Admin finishes
          finish_rooms[finish.id].each { |room| Room.find(room).finishes.destroy(finish) }
        end
      end
    end
  end

  class << self

    # initialse all the CAS data
    def initialise(developer_id)
      result = {result: :success}

      ActiveRecord::Base.transaction do
        begin
          Finishes.initialise developer_id
        rescue => e
          ActiveRecord::Rollback
          puts "*************************** error #{e.message}"
          result = {result: :fail, message: e.message}
        end
      end

      result
    end

  end
end
# rubocop:enable all
