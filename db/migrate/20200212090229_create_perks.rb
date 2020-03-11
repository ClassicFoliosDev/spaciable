class CreatePerks < ActiveRecord::Migration[5.0]
  def change
    create_table :premium_perks do |t|
      t.references :development, foreign_key: true
      t.boolean :enable_premium_perks, default: false
      t.integer :premium_licences_bought
      t.integer :premium_licence_duration

      t.timestamps
    end

    create_table :branded_perks do |t|
      t.references :developer, foreign_key: true
      t.string :link
      t.string :account_number
      t.string :tile_image
    end

    add_column :developers, :enable_perks, :boolean, default: false
  end
end
