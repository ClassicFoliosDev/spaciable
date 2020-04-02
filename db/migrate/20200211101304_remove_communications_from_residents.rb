class RemoveCommunicationsFromResidents < ActiveRecord::Migration[5.0]
  def change
    remove_column :residents, :post_updates, :boolean
    remove_column :residents, :developer_sms_updates, :boolean
  end
end