class AddColumnsToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :api_key, :string
    add_column :developers, :list_id, :string
  end
end
