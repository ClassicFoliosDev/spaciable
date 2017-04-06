class CreateHowTos < ActiveRecord::Migration[5.0]
  def change
    create_table :how_tos do |t|
      t.text :name
      t.text :summary
      t.text :description
      t.integer :category
      t.integer :featured
      t.string :picture

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
