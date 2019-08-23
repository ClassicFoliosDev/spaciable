class CreateLettings < ActiveRecord::Migration[5.0]
  def change
    create_table :lettings do |t|
      t.integer :bathrooms
      t.integer :bedrooms
      t.string :landlord_pets_policy
      t.boolean :has_car_parking
      t.boolean :has_bike_parking
      t.integer :property_type
      t.integer :price
      t.boolean :shared_accommodation
      t.string :notes
      t.string :summary

      t.string :access_token

      t.references :plot, foreign_key: true
      t.references :letter, polymorphic: true

      t.timestamps
    end
  end
end
