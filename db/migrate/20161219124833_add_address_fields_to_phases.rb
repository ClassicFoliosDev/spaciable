class AddAddressFieldsToPhases < ActiveRecord::Migration[5.0]
  def change
    add_column :phases, :postal_name, :string
    add_column :phases, :building_name, :string
    add_column :phases, :road_name, :string
    add_column :phases, :city, :string
    add_column :phases, :county, :string
    add_column :phases, :postcode, :string
  end
end
