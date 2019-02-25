class AddReceiveReleaseEmailsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :receive_release_emails, :boolean, :default => true
  end
end
