class AddSendToToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_reference :notifications, :send_to, polymorphic: true, index: true
  end
end
