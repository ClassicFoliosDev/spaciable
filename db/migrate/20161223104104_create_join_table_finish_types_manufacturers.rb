class CreateJoinTableFinishTypesManufacturers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :finish_types, :manufacturers do |t|
      t.index [:finish_type_id, :manufacturer_id], name: :finish_type_manufacturers_index
      t.index [:manufacturer_id, :finish_type_id], name: :manufacturer_finish_type_index
      t.timestamps
    end
  end
end
