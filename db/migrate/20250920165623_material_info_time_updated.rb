class MaterialInfoTimeUpdated < ActiveRecord::Migration[5.2]
  def change
    add_column :material_infos, :updated, :datetime, null: true
  end
end
