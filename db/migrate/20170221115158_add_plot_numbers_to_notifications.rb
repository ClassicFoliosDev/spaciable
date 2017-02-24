class AddPlotNumbersToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :plot_numbers, :string, array: true
  end
end
