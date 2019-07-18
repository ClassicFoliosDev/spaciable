class AddMaintenanceAutoPopulateToDevelopments < ActiveRecord::Migration[5.0]
  def change
    add_column :developments, :maintenance_auto_populate, :boolean, default: true
  end
end
