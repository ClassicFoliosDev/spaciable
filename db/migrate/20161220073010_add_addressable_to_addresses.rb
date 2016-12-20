class AddAddressableToAddresses < ActiveRecord::Migration[5.0]
  def change
    remove_column :addresses, :developer_id
    remove_column :addresses, :division_id
    add_reference :addresses, :addressable, polymorphic: true, index: true
  end
end
