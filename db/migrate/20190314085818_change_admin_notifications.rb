class ChangeAdminNotifications < ActiveRecord::Migration[5.0]
  def change
    change_column :admin_notifications, :send_to_all, :boolean, default: true
  end
end
