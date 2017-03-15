class AddTemplateRoomIdToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :template_room_id, :integer
  end
end
