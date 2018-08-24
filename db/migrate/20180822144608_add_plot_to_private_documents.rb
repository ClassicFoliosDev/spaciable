class AddPlotToPrivateDocuments < ActiveRecord::Migration[5.0]
  def change
    add_reference :private_documents, :plot, foreign_key: true, index: true, optional: true
  end
end
