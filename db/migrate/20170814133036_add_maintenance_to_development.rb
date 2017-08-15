class AddMaintenanceToDevelopment < ActiveRecord::Migration[5.0]
  def change
    add_column :developments, :maintenance_link, :string
  end
end
