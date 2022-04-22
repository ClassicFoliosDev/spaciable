class HillStyling < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :font, :string
    add_column :brands, :border_style, :integer, default: Brand.border_styles[:line]
    add_column :brands, :button_style, :integer, default: Brand.button_styles[:round]
    add_column :brands, :hero_height, :integer, default: 195
  end
end
