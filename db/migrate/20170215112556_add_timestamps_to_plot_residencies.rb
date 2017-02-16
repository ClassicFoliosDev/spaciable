class AddTimestampsToPlotResidencies < ActiveRecord::Migration[5.0]
  def change
    add_column :plot_residencies, :created_at, :datetime
    add_column :plot_residencies, :updated_at, :datetime
  end
end
