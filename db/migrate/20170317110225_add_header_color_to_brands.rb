class AddHeaderColorToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :header_color, :string
  end
end
