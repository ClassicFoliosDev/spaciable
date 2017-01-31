class AddPictureToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :picture, :string
  end
end
