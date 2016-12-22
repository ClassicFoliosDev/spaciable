class AddPictureToUnitTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :unit_types, :picture, :string
  end
end
