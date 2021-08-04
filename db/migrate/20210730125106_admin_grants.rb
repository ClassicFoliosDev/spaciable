class AdminGrants < ActiveRecord::Migration[5.0]
  def change
    create_table :grants do |t|
      t.references :user, foreign_key: true
      t.integer    :role
      t.references :grantable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
