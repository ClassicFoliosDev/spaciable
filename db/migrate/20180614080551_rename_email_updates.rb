class RenameEmailUpdates < ActiveRecord::Migration[5.0]
  def change
    rename_column :residents, :hoozzi_email_updates, :isyt_email_updates
  end
end
