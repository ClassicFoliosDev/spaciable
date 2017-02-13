class RenamePlotsResidentsToPlotResidency < ActiveRecord::Migration[5.0]
  def change
    rename_table :plots_residents, :plot_residencies
  end
end
