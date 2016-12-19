class RenamedDevelopmentNameToName < ActiveRecord::Migration[5.0]
  def change
    rename_column :developments, :development_name, :name
  end
end
