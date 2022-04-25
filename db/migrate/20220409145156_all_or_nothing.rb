class AllOrNothing < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|
      direction.up {
        Spotlight.update_all(all_or_nothing: :false)
        change_column_default :spotlights, :all_or_nothing, false
      }

      direction.down {
        change_column_default :spotlights, :all_or_nothing, true
      }
    end
  end
end
