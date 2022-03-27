class DynamicSpotlights < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
        create_table :spotlights do |t|
          t.references :development, index: true
          t.integer :category, default: Spotlight.categories[:static]
          t.boolean :cf, default: true
          t.boolean :editable, default: true
        end

        add_reference :custom_tiles, :spotlight, foreign_key: true
        add_column :custom_tiles, :order, :integer, default: 0
        add_column :custom_tiles, :appears_after, :integer, default: CustomTile.appears_afters[:emd]
        add_column :custom_tiles, :appears_after_date, :date
        add_column :custom_tiles, :expiry, :integer, default: CustomTile.expiries[:never]

        Rake::Task['dynamic_spotlights:migrate'].invoke
      }

      direction.down {
        remove_reference :custom_tiles, :spotlight, index: true
        drop_table :spotlights
        remove_column :custom_tiles, :order
        remove_column :custom_tiles, :appears_after
        remove_column :custom_tiles, :appears_after_date
        remove_column :custom_tiles, :expiry
      }
    end
  end
end
