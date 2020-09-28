class AddEditableToCustomTile < ActiveRecord::Migration[5.0]
  def change
    add_column :custom_tiles, :editable, :boolean, default: true

    CustomTile.all.each do |tile|
      tile.update_attribute(:editable, false) if tile.feature == ("services" || "perks")
    end
  end
end
