class AddLinkToManufacturers < ActiveRecord::Migration[5.0]
  def change
    add_column :manufacturers, :link, :string
  end
end
