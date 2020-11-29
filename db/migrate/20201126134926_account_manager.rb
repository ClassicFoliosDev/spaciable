class AccountManager < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :account_manager_name, :string
    add_column :developers, :account_manager_email, :string
    add_column :developers, :account_manager_contact, :string
  end
end
