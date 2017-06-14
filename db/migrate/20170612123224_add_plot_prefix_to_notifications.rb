class AddPlotPrefixToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :plot_prefix, :string
  end
end
