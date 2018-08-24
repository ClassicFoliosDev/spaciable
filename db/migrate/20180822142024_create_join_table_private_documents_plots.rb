class CreateJoinTablePrivateDocumentsPlots < ActiveRecord::Migration[5.0]
  def change
    create_join_table :private_documents, :plots do |t|
      t.boolean :enable_tenant_read, default: :false
      t.index [:private_document_id, :plot_id], name: :private_document_plot_index
      t.index [:plot_id, :private_document_id], name: :plot_private_document_index

      t.timestamps
    end
  end
end
