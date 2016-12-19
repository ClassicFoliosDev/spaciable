class RemoveAddressFromDivisions < ActiveRecord::Migration[5.0]
  def change
    remove_column :divisions, :address
    remove_column :divisions, :city
    remove_column :divisions, :county
    remove_column :divisions, :postcode
  end
end
