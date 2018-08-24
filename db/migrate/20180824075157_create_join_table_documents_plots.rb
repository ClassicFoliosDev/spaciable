class CreateJoinTableDocumentsPlots < ActiveRecord::Migration[5.0]
  def change
    create_join_table :documents, :plots do |t|
      t.boolean :enable_tenant_read, default: :false
      t.index [:document_id, :plot_id], name: :document_plot_index
      t.index [:plot_id, :document_id], name: :plot_document_index

      t.timestamps
    end
  end
end
