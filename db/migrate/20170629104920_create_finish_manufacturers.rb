class CreateFinishManufacturers < ActiveRecord::Migration[5.0]
  def change
    create_table :finish_manufacturers do |t|
      t.string :name
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
