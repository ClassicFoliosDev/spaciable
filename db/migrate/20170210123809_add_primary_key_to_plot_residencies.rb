class AddPrimaryKeyToPlotResidencies < ActiveRecord::Migration[5.0]
  def change
    add_column :plot_residencies, :id, :primary_key
  end
end
