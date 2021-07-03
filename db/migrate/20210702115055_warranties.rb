class Warranties < ActiveRecord::Migration[5.0]
  def change
     add_column :developers, :show_warranties, :boolean, default: true
  end
end
