class DoorkeeperDesc < ActiveRecord::Migration[5.0]
  def change
  	add_column :oauth_applications, :description, :string
  end
end
