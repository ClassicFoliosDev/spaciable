class RemoveLettings < ActiveRecord::Migration[5.0]
  def change
    drop_table :lettings
    drop_table :lettings_accounts
  end
end
