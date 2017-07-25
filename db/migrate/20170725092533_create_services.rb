class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :name
      t.string :description
      t.references :development, foreign_key: true

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
