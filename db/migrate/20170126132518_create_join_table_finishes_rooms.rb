class CreateJoinTableFinishesRooms < ActiveRecord::Migration[5.0]
  def change
    create_join_table :finishes, :rooms do |t|
      t.index [:finish_id, :room_id], name: :finish_room_index
      t.index [:room_id, :finish_id], name: :room_finish_index
      t.timestamps
    end
  end
end
