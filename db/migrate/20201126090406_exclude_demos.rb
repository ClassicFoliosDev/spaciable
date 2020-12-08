class ExcludeDemos < ActiveRecord::Migration[5.0]
   def change
   reversible do |direction|

      direction.up {
        add_column :developers, :is_demo, :boolean, default: false
      }

      direction.down {
        remove_column :developers, :is_demo
      }
    end
  end
end
