class AddRoleToPlotResidency < ActiveRecord::Migration[5.0]
  def change
    add_column :plot_residencies, :role, :integer
  end
end
