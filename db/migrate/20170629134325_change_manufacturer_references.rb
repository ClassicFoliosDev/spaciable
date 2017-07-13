class ChangeManufacturerReferences < ActiveRecord::Migration[5.0]
  def change
    add_reference :appliances, :appliance_manufacturer, index: true, foreign_key: true
    add_reference :finishes, :finish_manufacturer, index: true, foreign_key: true
    add_reference :finish_types_manufacturers, :finish_manufacturer, index: true, foreign_key: true
    add_reference :appliance_categories_manufacturers, :appliance_manufacturer, index: {name: "index_appliance_manufacturer"}, foreign_key: true

    add_index :appliance_categories_manufacturers, :appliance_category_id, name: "index_appliance_category"
    add_index :finish_types_manufacturers, :finish_type_id

    remove_index :appliance_categories_manufacturers, column: [:manufacturer_id, :appliance_category_id], name: "manufacturer_appliance_category_index"
    remove_index :appliance_categories_manufacturers, column: [:appliance_category_id, :manufacturer_id], name: "appliance_category_manufacturers_index"

    change_column :appliance_categories_manufacturers, :manufacturer_id, :integer, null: true
    change_column :finish_types_manufacturers, :manufacturer_id, :integer, null: true
  end
end
