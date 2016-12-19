class AddDeletedAtToPhases < ActiveRecord::Migration[5.0]
  def change
    add_column :phases, :deleted_at, :datetime
    add_index :phases, :deleted_at
  end
end
