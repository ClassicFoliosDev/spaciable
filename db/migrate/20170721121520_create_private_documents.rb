class CreatePrivateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :private_documents do |t|
      t.string :title
      t.string :file
      t.references :resident, foreign_key: true

      t.timestamps
    end
  end
end
