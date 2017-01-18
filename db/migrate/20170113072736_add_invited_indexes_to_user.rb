class AddInvitedIndexesToUser < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :invited_by_type
  end
end
