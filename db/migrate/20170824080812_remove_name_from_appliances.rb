class RemoveNameFromAppliances < ActiveRecord::Migration[5.0]
  def change
    remove_column :appliances, :name, :string
  end
end
