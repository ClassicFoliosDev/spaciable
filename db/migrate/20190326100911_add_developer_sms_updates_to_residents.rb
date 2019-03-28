class AddDeveloperSmsUpdatesToResidents < ActiveRecord::Migration[5.0]
  def change
    add_column :residents, :developer_sms_updates, :integer
  end
end
