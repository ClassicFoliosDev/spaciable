class AddDeletedAtToResidents < ActiveRecord::Migration[5.0]
  def change
    add_column :residents, :deleted_at, :datetime
  end
end
