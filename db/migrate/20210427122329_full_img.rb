class FullImg < ActiveRecord::Migration[5.0]
  def change
    add_column :custom_tiles, :render_title, :boolean, default: true
    add_column :custom_tiles, :render_description, :boolean, default: true
    add_column :custom_tiles, :render_button, :boolean, default: true
    add_column :custom_tiles, :full_image, :boolean, default: false
  end
end
