class AddCompletionDateToPlotResidencies < ActiveRecord::Migration[5.0]
  def change
    add_column :plot_residencies, :completion_date, :date
  end
end
