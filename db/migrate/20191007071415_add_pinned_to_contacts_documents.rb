class AddPinnedToContactsDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :pinned, :boolean, default: false
    add_column :documents, :pinned, :boolean, default: false
  end
end
