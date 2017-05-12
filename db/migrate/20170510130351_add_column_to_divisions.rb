class AddColumnToDivisions < ActiveRecord::Migration[5.0]
  def change
    add_column :divisions, :list_id, :string
  end
end
