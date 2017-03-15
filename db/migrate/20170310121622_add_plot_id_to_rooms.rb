class AddPlotIdToRooms < ActiveRecord::Migration[5.0]
  def change
    add_reference :rooms, :plot, foreign_key: true
  end
end
