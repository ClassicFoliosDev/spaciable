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
      t.string :address_1
      t.string :address_2
      t.string :town
      t.string :postcode
      t.string :country, :string, default: "UK"

      t.string :other_ref
      t.string :access_token

      t.references :plot, foreign_key: true
      t.references :lettings_account, foreign_key: true

      t.timestamps
    end
  end
end
