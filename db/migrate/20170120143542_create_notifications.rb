class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :subject
      t.text :message
      t.datetime :sent_at
      t.belongs_to :author, foreign_key: false
      t.belongs_to :sender, foreign_key: false

      t.timestamps
    end
  end
end
