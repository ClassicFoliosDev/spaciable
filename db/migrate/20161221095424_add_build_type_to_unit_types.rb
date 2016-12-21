class AddBuildTypeToUnitTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :unit_types, :build_type, :integer, default: 0
  end
end
