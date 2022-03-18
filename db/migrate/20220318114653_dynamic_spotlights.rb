class DynamicSpotlights < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
        create_table :spotlights do |t|
          t.references :development, index: true
          t.boolean :cf, default: true
        end

        add_reference :custom_tiles, :spotlight, foreign_key: true
        add_column :custom_tiles, :order, :integer, default: 1

        Rake::Task['dynamic_spotlights:migrate'].invoke
      }

      direction.down {
        remove_reference :custom_tiles, :spotlight, index: true
        drop_table :spotlights
        remove_column :custom_tiles, :order
      }
    end
  end
end
