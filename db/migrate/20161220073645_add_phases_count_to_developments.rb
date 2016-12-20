class AddPhasesCountToDevelopments < ActiveRecord::Migration[5.0]
  def change
    add_column :developments, :phases_count, :integer, default: 0
  end
end
