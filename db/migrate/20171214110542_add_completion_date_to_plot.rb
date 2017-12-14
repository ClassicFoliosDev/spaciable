class AddCompletionDateToPlot < ActiveRecord::Migration[5.0]
  def change
    add_column :plots, :completion_date, :date
  end
end
