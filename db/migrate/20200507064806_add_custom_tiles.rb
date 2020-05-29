class AddCustomTiles < ActiveRecord::Migration[5.0]
  def up
    create_table :custom_tiles do |t|
      t.string :title
      t.string :description
      t.string :button
      t.string :image

      t.integer :category, default: 0
      t.string :link
      t.integer :feature
      t.integer :guide
      t.string :file
      t.references :document, foreign_key: true
      t.references :development, foreign_key: true
    end

    # add guide to documents table
    add_column :documents, :guide, :integer

    # migrate custom tiles for existing developments
    load Rails.root.join("db/seeds", "custom_tiles.rb")
  end

  def down
    CustomTile.destroy_all
    drop_table :custom_tiles

    remove_column :documents, :guide, :integer
  end
end
