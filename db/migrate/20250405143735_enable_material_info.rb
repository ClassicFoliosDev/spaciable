class EnableMaterialInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :developers, :enable_material_info, :boolean, default: false
  end
end
