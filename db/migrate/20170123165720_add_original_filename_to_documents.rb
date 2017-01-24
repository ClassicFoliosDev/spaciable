class AddOriginalFilenameToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :original_filename, :string
  end
end
