class AddOrderNumberToPlots < ActiveRecord::Migration[5.0]
  def change
    add_column :plots, :completion_order_number, :string
    add_column :plots, :reservation_order_number, :string
  end
end
