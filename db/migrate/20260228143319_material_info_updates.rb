class MaterialInfoUpdates < ActiveRecord::Migration[5.2]
  def change
    change_column :material_infos, :service_charges, :decimal, precision: 10, scale: 2

    Rake::Task['material_info:migrate_property_types'].invoke
  end
end
