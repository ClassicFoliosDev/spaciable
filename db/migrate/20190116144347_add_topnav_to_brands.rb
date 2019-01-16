class AddTopnavToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :topnav_text, :string
  end
end
