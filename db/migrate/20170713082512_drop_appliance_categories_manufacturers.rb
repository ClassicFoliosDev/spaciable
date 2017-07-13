class DropApplianceCategoriesManufacturers < ActiveRecord::Migration[5.0]
  def change
    drop_table :appliance_categories_manufacturers
  end
end
