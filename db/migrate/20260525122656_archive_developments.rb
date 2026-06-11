class ArchiveDevelopments < ActiveRecord::Migration[5.2]
  def change
    add_column :developments, :archive, :boolean, default: false
  end
end
