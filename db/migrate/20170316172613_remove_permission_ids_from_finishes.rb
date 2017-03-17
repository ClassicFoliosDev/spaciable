class RemovePermissionIdsFromFinishes < ActiveRecord::Migration[5.0]
  def change
    remove_column :finishes, :developer_id, :integer
    remove_column :finishes, :division_id, :integer
    remove_column :finishes, :development_id, :integer
  end
end
