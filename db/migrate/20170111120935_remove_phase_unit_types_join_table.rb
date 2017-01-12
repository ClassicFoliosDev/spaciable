class RemovePhaseUnitTypesJoinTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :phases_unit_types
  end
end
