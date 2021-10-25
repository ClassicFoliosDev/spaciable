class SaaS < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
         add_column :phases, :package, :integer, default: Phase.packages[:legacy]
      }

      direction.down {
        remove_column :phases, :package
      }
    end
  end
end
