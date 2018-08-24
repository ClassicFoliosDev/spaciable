class AddPlotDocumentsPrimaryKey < ActiveRecord::Migration[5.0]
  def change
    add_column :documents_plots, :id, :primary_key
  end
end
