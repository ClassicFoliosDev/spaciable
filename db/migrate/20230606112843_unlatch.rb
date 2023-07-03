class Unlatch < ActiveRecord::Migration[5.0]
  def change
    add_column :phases, :unlatch_program_id, :integer
  end
end
