class AddColumnToUnitTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :unit_types, :external_link, :string
  end
end
