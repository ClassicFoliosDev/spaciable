class DeleteAllHomeowners < ActiveRecord::Migration[5.0]
  def up
    User.where(role: 4).delete_all
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
