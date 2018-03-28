class AddHideToHowTos < ActiveRecord::Migration[5.0]
  def change
    add_column :how_tos, :hide, :boolean, default: false
  end
end
