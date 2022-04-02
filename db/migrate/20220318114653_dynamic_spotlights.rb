class DynamicSpotlights < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
        create_table :spotlights do |t|
          t.references :development, index: true
          t.integer :category, default: Spotlight.categories[:static]
          t.boolean :cf, default: true
          t.boolean :editable, default: true
          t.integer :appears, default: Spotlight.appears[:always]
          t.integer :expiry, default: Spotlight.expiries[:never]
          t.date :start
          t.date :finish
        end

        add_reference :custom_tiles, :spotlight, foreign_key: true
        add_column :custom_tiles, :order, :integer, default: 0

        Rake::Task['dynamic_spotlights:migrate'].invoke

        remove_column :custom_tiles, :cf
        remove_column :custom_tiles, :editable
        remove_column :custom_tiles, :appears
        remove_reference :custom_tiles, :development
      }

      direction.down {
        remove_reference :custom_tiles, :spotlight, index: true
        drop_table :spotlights
        remove_column :custom_tiles, :order
        add_column :custom_tiles, :cf, :boolean, default: true
        add_column :custom_tiles, :editable, :boolean, default: true
        add_column :custom_tiles, :appears, :integer, default: CustomTile.appears[:always]
        add_reference :custom_tiles, :development, foreign_key: true
      }
    end
  end
end
