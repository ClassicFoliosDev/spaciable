class AddFieldsToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :building_name, :string
    add_column :addresses, :road_name, :string
  end
end
