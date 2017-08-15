class AddHouseSearchToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :house_search, :boolean
  end
end
