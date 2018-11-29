class AddFinishRoomsIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :finishes_rooms, [:finish_id, :room_id], unique: true, name: 'by_finish_and_by_room'
  end
end
