class RemoveLettings < ActiveRecord::Migration[5.0]
  def change
    drop_table :lettings
  end
end
