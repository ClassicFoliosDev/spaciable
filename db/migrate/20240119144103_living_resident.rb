class LivingResident < ActiveRecord::Migration[5.2]
  def change
    add_column :residents, :living, :boolean, default: false
  end
end
