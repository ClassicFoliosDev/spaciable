class AddFileTmpToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :file_tmp, :string
  end
end
