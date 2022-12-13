class ExtendResident < ActiveRecord::Migration[5.0]
  def change
  	add_column :residents, :extended_until, :datetime, default: nil
  end
end
