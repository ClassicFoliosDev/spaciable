class CreateAppliances < ActiveRecord::Migration[5.0]
  def change
    create_table :appliances do |t|
      t.string :name
      t.string :primary_image
      t.string :images
      t.string :manual
      t.integer :manufacturer
      t.string :serial
      t.integer :category
      t.string :source
      t.string :service_log
      t.string :warranty_num
      t.integer :warranty_length
      t.string :model_num
      t.integer :e_rating

      t.timestamps
    end
  end
end
