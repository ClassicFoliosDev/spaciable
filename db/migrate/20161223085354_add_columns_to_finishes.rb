class AddColumnsToFinishes < ActiveRecord::Migration[5.0]
  def change
    add_column :finishes, :type, :integer
    add_column :finishes, :description, :string
    remove_column :finishes, :category
  end
end
