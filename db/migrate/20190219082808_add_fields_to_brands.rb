class AddFieldsToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :login_box_left_color, :string
    add_column :brands, :login_box_right_color, :string
    add_column :brands, :login_button_static_color, :string
    add_column :brands, :login_button_hover_color, :string
    add_column :brands, :content_box_color, :string
    add_column :brands, :content_box_outline_color, :string
    add_column :brands, :text_left_color, :string
    add_column :brands, :text_right_color, :string
    add_column :brands, :login_logo, :string
  end
end
