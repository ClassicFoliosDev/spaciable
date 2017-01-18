class CreateJoinTableAppliancesRooms < ActiveRecord::Migration[5.0]
  def change
    create_join_table :appliances, :rooms do |t|
      t.index [:appliance_id, :room_id], name: :appliance_room_index
      t.index [:room_id, :appliance_id], name: :room_appliance_index
      t.timestamps
    end
  end
end
