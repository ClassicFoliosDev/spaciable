class SaaS < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
         add_column :phases, :package, :integer, default: Phase.packages[:legacy]
         add_column :custom_tiles, :cf, :boolean, default: true
      }

      direction.down {
        remove_column :phases, :package
        remove_column :custom_tiles, :cf
      }
    end
  end
end
