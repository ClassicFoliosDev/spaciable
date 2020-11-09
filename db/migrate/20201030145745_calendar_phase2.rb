class CalendarPhase2 < ActiveRecord::Migration[5.0]
 def change
   reversible do |direction|

      direction.up {

        # Events can only have one single reproposed time
        # so move them from EventResource to Event
        remove_column :event_resources, :proposed_start
        remove_column :event_resources, :proposed_end
        add_column :events, :proposed_start, :datetime
        add_column :events, :proposed_end, :datetime
      }

      direction.down {
        add_column :event_resources, :proposed_start, :datetime
        add_column :event_resources, :proposed_end, :datetime
        remove_column :events, :proposed_start
        remove_column :events, :proposed_end
      }
    end
  end
end
