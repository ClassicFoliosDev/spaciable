class AddCustomTiles < ActiveRecord::Migration[5.0]
  def up
    create_table :custom_tiles do |t|
      t.string :title
      t.string :description
      t.string :button
      t.string :image

      t.integer :category
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
    @cat = 0
    @referrals = 2
    @services = 3
    @perks = 4

    Development.all.each do |dev|
      parent_developer =  dev.developer || dev.division.developer

      if parent_developer.enable_referrals
        execute "insert into custom_tiles (development_id, category, feature)
                 values (#{dev.id}, #{@cat}, #{@referrals})"
      end
      if parent_developer.enable_services
        execute "insert into custom_tiles (development_id, category, feature)
                 values (#{dev.id}, #{@cat}, #{@services})"
      end
      if parent_developer.enable_perks
        execute "insert into custom_tiles (development_id, category, feature)
                 values (#{dev.id}, #{@cat}, #{@perks})"
      end
    end
  end

  def down
    CustomTile.all.each do |tile|
      tile.destroy!
    end
    drop_table :custom_tiles

    remove_column :documents, :guide, :integer
  end
end
