class AddRoomsketcherToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :enable_roomsketcher, :boolean, default: true
  end
end
