class AddDeleteAtToPlots < ActiveRecord::Migration[5.0]
  def change
    add_column :plots, :deleted_at, :datetime
    add_index :plots, :deleted_at
  end
end
