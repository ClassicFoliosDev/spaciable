class AddBusinessToPhases < ActiveRecord::Migration[5.0]
  def change
    add_column :phases, :business, :integer, default: 0
  end
end
