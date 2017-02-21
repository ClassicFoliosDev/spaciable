class AddIconToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :icon_name, :integer
  end
end
