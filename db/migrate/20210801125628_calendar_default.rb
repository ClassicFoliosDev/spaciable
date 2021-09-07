class CalendarDefault < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
         change_column_default :developments, :calendar, true
      }

      direction.down {
        # do nothing
      }
    end
  end
end
