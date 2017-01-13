class RemoveAddrFieldsFromDeveloper < ActiveRecord::Migration[5.0]
  def change
    remove_column :developers, :city
    remove_column :developers, :county
    remove_column :developers, :postcode
    remove_column :developers, :postal_name
    remove_column :developers, :building_name
    remove_column :developers, :road_name
  end
end
