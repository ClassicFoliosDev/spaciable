class RemoveTypeFromFinishes < ActiveRecord::Migration[5.0]
  def change
    remove_column :finishes, :type, :integer
  end
end
