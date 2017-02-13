class AddPermissionIdsToContacts < ActiveRecord::Migration[5.0]
  def change
    add_reference :contacts, :developer, foreign_key: true
    add_reference :contacts, :division, foreign_key: true
    add_reference :contacts, :development, foreign_key: true
  end
end
