class AddAboutToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :about, :text
  end
end
