class AddDeletedAtToUnitTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :unit_types, :deleted_at, :datetime
  end
end
