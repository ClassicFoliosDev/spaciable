class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.text :name

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
