class AddProgressToPlot < ActiveRecord::Migration[5.0]
  def change
    add_column :plots, :progress, :integer, default: 0
  end
end
