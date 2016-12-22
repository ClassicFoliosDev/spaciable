class AddDeletedAtToFinishes < ActiveRecord::Migration[5.0]
  def change
    add_column :finishes, :deleted_at, :datetime
    add_index :finishes, :deleted_at
  end
end
