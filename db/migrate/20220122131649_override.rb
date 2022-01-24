class Override < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :override, :boolean, default: false
    add_column :videos, :override, :boolean, default: false
  end
end
