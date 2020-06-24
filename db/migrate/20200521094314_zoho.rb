class Zoho < ActiveRecord::Migration[5.0]
  def change

    create_table :crms do |t|
      t.references :developer, foreign_key: true
      t.string :name
      t.string :client_id
      t.string :client_secret
      t.string :redirect_uri
      t.string :current_user_email
      t.string :accounts_url
      t.string :api_base_url
      t.string :token_persistence_path
    end

  end
end
