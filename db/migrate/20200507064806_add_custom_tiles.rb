class AddCustomTiles < ActiveRecord::Migration[5.0]
  def change
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

      t.timestamps
    end

    # add guide to documents table
    add_column :documents, :guide, :integer

    # migrate custom tiles for existing developments
    Development.all.each do |development|
      parent_developer =  development.developer || development.division.developer
      category = 'feature'
      CustomTile.create(development_id: development.id,
                        category: category,
                        feature: 'referrals') if parent_developer.enable_referrals
      CustomTile.create(development_id: development.id,
                        category: category,
                        feature: 'services') if parent_developer.enable_services
      CustomTile.create(development_id: development.id,
                        category: category,
                        feature: 'perks') if parent_developer.enable_perks
    end
  end
end
