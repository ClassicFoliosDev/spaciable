class RemoveNonPolymorphicIds < ActiveRecord::Migration[5.0]
  def change
    remove_column :contacts, :development_id, :integer
    remove_column :contacts, :division_id, :integer
    remove_column :contacts, :developer_id, :integer
    remove_column :faqs, :development_id, :integer
    remove_column :faqs, :division_id, :integer
    remove_column :faqs, :developer_id, :integer
    remove_column :documents, :development_id, :integer
    remove_column :documents, :division_id, :integer
    remove_column :documents, :developer_id, :integer
  end
end
