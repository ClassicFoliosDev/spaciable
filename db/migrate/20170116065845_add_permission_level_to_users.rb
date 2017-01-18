class AddPermissionLevelToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :permission_level, polymorphic: true

    remove_column :users, :developer_id
    remove_column :users, :division_id
    remove_column :users, :development_id
  end
end
