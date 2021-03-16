class NotificationFilter < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :plot_filter, :integer, default: 0
  end
end
