class ChangePlotNumberToDecimalType < ActiveRecord::Migration[5.0]
  def change
    change_column :plots, :number, :decimal
  end
end
