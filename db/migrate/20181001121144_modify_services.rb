class ModifyServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :category, :integer
  end
end
