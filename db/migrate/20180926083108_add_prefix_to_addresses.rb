class AddPrefixToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :prefix, :string
  end
end
