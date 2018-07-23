class AddPlotReleaseDates < ActiveRecord::Migration[5.0]
  def change
    add_column :plots, :completion_release_date, :date, default: nil
    add_column :plots, :reservation_release_date, :date, default: nil
    add_column :plots, :validity, :integer, default: 24
    add_column :plots, :extended_access, :integer, default: 0
  end
end
