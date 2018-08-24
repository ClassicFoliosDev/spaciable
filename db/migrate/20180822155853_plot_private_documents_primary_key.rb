class PlotPrivateDocumentsPrimaryKey < ActiveRecord::Migration[5.0]
  def change
    add_column :plots_private_documents, :id, :primary_key
  end
end
