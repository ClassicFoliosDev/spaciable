class CreateJoinTableApplianceCategoriesManufacturers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :appliance_categories, :manufacturers do |t|
      t.index [:appliance_category_id, :manufacturer_id], name: :appliance_category_manufacturers_index
      t.index [:manufacturer_id, :appliance_category_id], name: :manufacturer_appliance_category_index
      t.timestamps
    end
  end
end
