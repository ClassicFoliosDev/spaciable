class AddCategoryToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :category, :integer
  end
end
