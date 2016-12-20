class RemoveAddressFieldsFromDevelopmentsAndPhases < ActiveRecord::Migration[5.0]
  def change
    remove_column :developments, :postal_name
    remove_column :developments, :building_name
    remove_column :developments, :road_name
    remove_column :developments, :city
    remove_column :developments, :county
    remove_column :developments, :postcode

    remove_column :phases, :postal_name
    remove_column :phases, :building_name
    remove_column :phases, :road_name
    remove_column :phases, :city
    remove_column :phases, :county
    remove_column :phases, :postcode
  end
end
