class AddPgTrgmExtension < ActiveRecord::Migration[5.0]
  #def change
  #  execute "create extension pg_trgm;"
  #end
  def up
    execute "CREATE EXTENSION pg_trgm"
  end

  def down
    execute "drop extension pg_trgm"
  end
end
