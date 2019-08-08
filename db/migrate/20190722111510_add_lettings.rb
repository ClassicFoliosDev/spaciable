class AddLettings < ActiveRecord::Migration[5.0]
  def change
    add_column :phases, :lettings, :boolean, default: :false

    add_column :plots, :letable, :boolean, default: :false
    add_column :plots, :let, :boolean, default: :false
  end
end
