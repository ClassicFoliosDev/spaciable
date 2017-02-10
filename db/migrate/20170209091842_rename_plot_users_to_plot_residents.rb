class RenamePlotUsersToPlotResidents < ActiveRecord::Migration[5.0]
  def change
    drop_table :plots_users

    create_join_table :plots, :residents do |t|
      t.references :plot, foreign_key: true
      t.references :resident, foreign_key: true
    end
  end
end
