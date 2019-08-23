class RemoveLettingsInfo < ActiveRecord::Migration[5.0]
  def change
    remove_column :developers, :lettings_email
    remove_column :developers, :lettings_first_name
    remove_column :developers, :lettings_last_name
    remove_column :developers, :lettings_management
    remove_column :developers, :lettings_access_token
    remove_column :developers, :lettings_refresh_token

    remove_reference :lettings, :letter

    remove_column :residents, :lettings_management
    remove_column :residents, :lettings_access_token
    remove_column :residents, :lettings_refresh_token
  end
end
