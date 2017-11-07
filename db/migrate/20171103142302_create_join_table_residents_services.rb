class CreateJoinTableResidentsServices < ActiveRecord::Migration[5.0]
  def change
    create_join_table :residents, :services do |t|
      t.index [:resident_id, :service_id]
      t.index [:service_id, :resident_id]
      t.timestamps
    end
  end
end
