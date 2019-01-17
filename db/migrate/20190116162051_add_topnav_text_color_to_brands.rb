class AddTopnavTextColorToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :topnav_text_color, :string
  end
end
