class CustomTileFilenames < ActiveRecord::Migration[5.0]
  def change
    add_column :custom_tiles, :original_filename, :string
  end
end
