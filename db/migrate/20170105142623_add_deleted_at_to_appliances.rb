class AddDeletedAtToAppliances < ActiveRecord::Migration[5.0]
  def change
    add_column :appliances, :deleted_at, :datetime
    add_index :appliances, :deleted_at
  end
end
