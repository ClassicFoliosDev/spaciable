class AddUprnToPlots < ActiveRecord::Migration[5.0]
  def change
    add_column :plots, :uprn, :string
  end
end
