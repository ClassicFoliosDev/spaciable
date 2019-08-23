class CreateLettingsAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :lettings_accounts do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :management, default: 0

      t.references :letter, polymorphic: true

      t.timestamps
    end
  end
end
