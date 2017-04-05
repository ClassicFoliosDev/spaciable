class ChangePlotsNumberToString < ActiveRecord::Migration[5.0]
  def change
    change_column :plots, :number, :string
  end
end
