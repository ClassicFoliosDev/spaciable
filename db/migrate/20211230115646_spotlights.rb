class Spotlights < ActiveRecord::Migration[5.0]
  def change
    add_column :custom_tiles, :appears, :integer, default: CustomTile.appears[:always]
  end
end
