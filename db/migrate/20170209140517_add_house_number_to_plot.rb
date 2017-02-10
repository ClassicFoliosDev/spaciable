class AddHouseNumberToPlot < ActiveRecord::Migration[5.0]
  def change
    add_column :plots, :house_number, :string
  end
end
