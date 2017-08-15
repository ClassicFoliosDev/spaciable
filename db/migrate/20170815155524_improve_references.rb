class ImproveReferences < ActiveRecord::Migration[5.0]
  def change
    remove_reference :appliances, :manufacturer, index: true
    remove_reference :finishes, :manufacturer, index: true

    remove_index :finish_types_manufacturers, column: [:manufacturer_id, :finish_type_id], name: "manufacturer_finish_type_index"
    remove_index :finish_types_manufacturers, column: [:finish_type_id, :manufacturer_id], name: "finish_type_manufacturers_index"

    remove_index :appliances, column: [:name], name: "index_appliances_on_name"
  end
end
