class RemoveBusinessFromDevelopment < ActiveRecord::Migration[5.0]
  def change
    remove_column :developments, :business
  end
end
