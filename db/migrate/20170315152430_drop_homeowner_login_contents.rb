class DropHomeownerLoginContents < ActiveRecord::Migration[5.0]
  def up
    drop_table :homeowner_login_contents
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
