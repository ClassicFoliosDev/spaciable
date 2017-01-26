class RemoveColumnsFromAppliances < ActiveRecord::Migration[5.0]
  def change
    remove_column :appliances, :source
    remove_column :appliances, :serial
  end
end
