class CreateCcEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :cc_emails do |t|
      t.references :user, foreign_key: true
      t.integer :email_type
      t.string :email_list
    end
  end
end
