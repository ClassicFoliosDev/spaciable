class AddTitleToResidents < ActiveRecord::Migration[5.0]
  def change
    add_column :residents, :title, :integer, default: 0
  end
end
