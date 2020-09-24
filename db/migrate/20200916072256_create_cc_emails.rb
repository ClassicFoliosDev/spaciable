class CreateCcEmails < ActiveRecord::Migration[5.0]
  def up
    create_table :cc_emails do |t|
      t.references :user, foreign_key: true
      t.integer :email_type
      t.string :email_list
    end

    # create the cc_email records for existing users
    load Rails.root.join("db/seeds", "cc_emails.rb")
  end

  def down
    CcEmail.destroy_all
    drop_table :cc_emails
  end
end
