class AddLocalityToAddress < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :locality, :string
    rename_column :addresses, :postal_name, :postal_number
  end
end
