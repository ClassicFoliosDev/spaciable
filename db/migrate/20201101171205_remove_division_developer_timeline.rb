class RemoveDivisionDeveloperTimeline < ActiveRecord::Migration[5.0]
  def change
   reversible do |direction|

      direction.up {
        remove_column :divisions, :timeline_id
        remove_column :developments, :timeline_id
      }

      direction.down {
        add_column :divisions, :timeline_id, :integer
        add_column :developments, :timeline_id, :integer
      }
    end
  end
end
