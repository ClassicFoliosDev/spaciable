class AddLettings < ActiveRecord::Migration[5.0]
  def change
    #create_table :lettings do |t|
     # t.integer :bathrooms
      #t.integer :bedrooms
      #t.string :landlord_pets_policy
      #t.boolean :has_car_parking
      #t.boolean :has_bike_parking
      #t.integer :property_type
      #t.integer :price
      #t.boolean :shared_accommodation
      #t.string :notes
      #t.string :summary
      #t.string :address_1
      #t.string :address_2
      #t.string :town
      #t.string :postcode
      #t.string :country, :string, default: "UK"

      #t.string :other_ref
      #t.string :access_token

      #t.references :plot, foreign_key: true
      #t.references :lettings_account, foreign_key: true

      #t.timestamps
    #end

    #create_table :lettings_accounts do |t|
     # t.string :access_token
     # t.string :refresh_token
     # t.string :first_name
     # t.string :last_name
     # t.string :email
     # t.integer :management, default: 0

     # t.references :letter, polymorphic: true

     # t.timestamps
    #end

    #add_column :plots, :letable, :boolean, default: false
    #add_column :plots, :let, :boolean, default: false
    #add_column :plots, :letable_type, :integer
    #add_column :plots, :letter_type, :integer
  end
end
