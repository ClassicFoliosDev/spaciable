class AddReadAtToResidentNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :resident_notifications, :read_at, :datetime
  end
end
