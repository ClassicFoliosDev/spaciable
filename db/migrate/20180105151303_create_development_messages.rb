class CreateDevelopmentMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :development_messages do |t|
      t.string :subject, length: 100
      t.string :content

      t.references :parent, index: true
      t.references :development, foreign_key: true
      t.references :resident, foreign_key: true

      t.timestamps
    end
  end
end
