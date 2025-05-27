class AutoCompleteTask < ActiveRecord::Migration[5.2]
  def change
    add_column :developers, :auto_complete, :integer, default: 24
  end
end
