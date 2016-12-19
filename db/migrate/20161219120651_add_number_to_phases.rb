class AddNumberToPhases < ActiveRecord::Migration[5.0]
  def change
    add_column :phases, :number, :integer
  end
end
