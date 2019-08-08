class ChangeLettings < ActiveRecord::Migration[5.0]
  def change
    change_column :phases, :lettings, :boolean, default: true
    change_column :plots, :letable, :boolean, default: true
  end
end
