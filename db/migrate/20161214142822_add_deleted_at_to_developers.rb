class AddDeletedAtToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :deleted_at, :datetime
    add_index :developers, :deleted_at
  end
end
