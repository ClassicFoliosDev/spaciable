class AddCustomTextToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :content_box_text, :string
    add_column :brands, :heading_one, :string
    add_column :brands, :heading_two, :string
    add_column :brands, :info_text, :string
  end
end
