class AddDeleteAtToPlotResidencies < ActiveRecord::Migration[5.0]
  def change
    add_column :plot_residencies, :deleted_at, :datetime
  end
end
