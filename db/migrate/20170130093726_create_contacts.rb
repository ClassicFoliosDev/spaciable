class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.integer :title
      t.string :position
      t.integer :category
      t.string :email
      t.string :phone
      t.string :mobile
      t.datetime :deleted_at
      t.index :deleted_at

      t.timestamps
    end
  end
end
