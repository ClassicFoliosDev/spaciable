class Logging < ActiveRecord::Migration[5.0]
  def change

    create_table :logs do |t|
      t.references :logable, polymorphic: true, index: true
      t.string  :primary
      t.string  :secondary
      t.integer :action
      t.string  :username
      t.integer :role
      t.timestamps
    end

  end
end
