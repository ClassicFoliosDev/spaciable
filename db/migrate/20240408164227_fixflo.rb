class Fixflo < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenances, :fixflow_direct, :boolean, default: false
  end
end
