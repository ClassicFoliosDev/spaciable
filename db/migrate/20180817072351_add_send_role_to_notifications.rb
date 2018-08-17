class AddSendRoleToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :send_to_role, :integer
  end
end
