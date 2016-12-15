class AddExtraAddressLinesToDeveloper < ActiveRecord::Migration[5.0]
  def change
    rename_column :developers, :head_office_address, :postal_name
    add_column :developers, :building_name, :string
    add_column :developers, :road_name, :string
  end
end
