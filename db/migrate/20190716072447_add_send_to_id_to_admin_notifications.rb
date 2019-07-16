class AddSendToIdToAdminNotifications < ActiveRecord::Migration[5.0]
  def change
    add_reference :admin_notifications, :send_to, polymorphic: true, index: true
    change_column :admin_notifications, :send_to_all, :boolean, default: false
  end
end
