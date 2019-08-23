class AddAddressToLettings < ActiveRecord::Migration[5.0]
  def change
    add_column :lettings, :other_ref, :string

    add_column :lettings, :address_1, :string
    add_column :lettings, :address_2, :string
    add_column :lettings, :postcode, :string
    add_column :lettings, :country, :string, default: "UK"
    add_column :lettings, :town, :string
  end
end
