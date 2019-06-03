class CreateSnags < ActiveRecord::Migration[5.0]
  def change
    create_table :snags do |t|
      t.string :title
      t.text :description
      t.integer :status, default: 0
      t.references :plot, foreign_key: true, index: true

      t.timestamps
    end
  end
end
