class PhaseConveyencing < ActiveRecord::Migration[5.0]
  def change
    add_column :phases, :conveyancing, :boolean, default: true
  end
end
