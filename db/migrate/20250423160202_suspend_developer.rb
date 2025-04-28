class SuspendDeveloper < ActiveRecord::Migration[5.2]
  def change
    add_column :developers, :suspended, :boolean, default: false
  end
end
