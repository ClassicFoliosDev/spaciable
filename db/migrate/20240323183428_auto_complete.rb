class AutoComplete < ActiveRecord::Migration[5.2]
  def change
    add_column :plots, :auto_completed, :datetime, default: nil
  end
end
