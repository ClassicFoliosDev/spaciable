class UserBypass < ActiveRecord::Migration[5.2]
  def change
    add_column :residents, :bypass, :boolean, default: false
  end
end
