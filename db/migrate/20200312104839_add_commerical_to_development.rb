class AddCommericalToDevelopment < ActiveRecord::Migration[5.0]
  def change
    add_column :developments, :construction, :integer, default: 0, null: false
    add_column :developments, :construction_name, :string
  end
end
