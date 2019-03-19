class RemoveColumnsFromAdminNotifications < ActiveRecord::Migration[5.0]
  def change
    remove_column :admin_notifications, :send_to_role
    remove_column :admin_notifications, :send_to_id
  end
end
