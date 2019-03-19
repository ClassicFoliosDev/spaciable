class CreateAdminNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_notifications do |t|
      t.string :subject
      t.text :message
      t.datetime :sent_at
      t.integer :author_id
      t.integer :sender_id
      t.datetime :created_at
      t.integer :send_to_role
      t.integer :send_to_id
      t.boolean :send_to_all, default: false

      t.belongs_to :author, foreign_key: false
      t.belongs_to :sender, foreign_key: false

      t.timestamps
    end
  end
end
