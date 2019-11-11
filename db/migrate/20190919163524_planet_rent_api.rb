class PlanetRentApi < ActiveRecord::Migration[5.0]

  def up
  	# agencies (developers) and landlords have different account structures
  	# so drop the generic lettings_accounts table
    drop_table :lettings
  	drop_table :lettings_accounts

  	create_table :access_tokens do |t|
  		t.string :access_token
  		t.string :refresh_token
  		t.integer :expires_at
  	end

  	# A landlord account is only used by a single resident
  	create_table :lettings_accounts do |t|
  		t.string :reference, default: nil
  		t.references :access_token
  		t.integer :authorisation_status, default: 0
      t.integer :management, default: 0
      t.belongs_to :accountable, polymorphic: true, index: true
  	end

    # lettings becomes listings
  	create_table :listings do |t|
  		t.string :reference, default: nil
  		t.string :other_ref, default: nil
  		t.integer :owner, null: false
  		t.belongs_to :lettings_account, index: true
  		t.belongs_to :plot, null: false, index: { unique: true }
  	end

  	# update plots
  	remove_columns :plots, :letable, :let, :letable_type, :letter_type

    # Users can be allocated lettings management responsibilities
    add_column :users, :lettings_management, :integer, default: 0
  end

  def down

    drop_table :listings
    drop_table :lettings_accounts
    drop_table :access_tokens

    remove_columns :users, :lettings_management

    add_column :plots, :letable, :boolean, default: false
    add_column :plots, :let, :boolean, default: false
    add_column :plots, :letable_type, :integer
    add_column :plots, :letter_type, :integer

    create_table :lettings_accounts do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :management, default: 0

      t.references :letter, polymorphic: true

      t.timestamps
    end

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
