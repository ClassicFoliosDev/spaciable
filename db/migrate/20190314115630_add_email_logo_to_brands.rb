class AddEmailLogoToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :email_logo, :string
  end
end
