class AddColumnsToResidents < ActiveRecord::Migration[5.0]
  def change
    add_column :residents, :developer_email_updates, :integer
    add_column :residents, :hoozzi_email_updates, :integer
    add_column :residents, :telephone_updates, :integer
    add_column :residents, :post_updates, :integer
  end
end
