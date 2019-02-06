class AddBusinessToDevelopments < ActiveRecord::Migration[5.0]
  def change
    add_column :developments, :business, :integer, default: 0
  end
end
