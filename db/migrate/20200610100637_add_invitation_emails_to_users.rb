class AddInvitationEmailsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :receive_invitation_emails, :boolean, default: true
  end
end
