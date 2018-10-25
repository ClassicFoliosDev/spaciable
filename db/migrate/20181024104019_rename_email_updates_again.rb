class RenameEmailUpdatesAgain < ActiveRecord::Migration[5.0]
  def change
    rename_column :residents, :isyt_email_updates, :cf_email_updates
  end
end
