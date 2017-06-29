class AddLoginImageToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :login_image, :string
  end
end
