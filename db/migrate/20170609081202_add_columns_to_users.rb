class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :picture, :string
    add_column :users, :job_title, :string
  end
end
