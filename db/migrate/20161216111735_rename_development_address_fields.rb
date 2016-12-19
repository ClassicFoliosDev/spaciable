class RenameDevelopmentAddressFields < ActiveRecord::Migration[5.0]
  def change
    rename_column :developments, :office_address, :postal_name
    add_column :developments, :building_name, :string
    add_column :developments, :road_name, :string
  end
end
