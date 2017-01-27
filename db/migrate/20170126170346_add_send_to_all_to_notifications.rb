class AddSendToAllToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :send_to_all, :boolean, default: false
  end
end
