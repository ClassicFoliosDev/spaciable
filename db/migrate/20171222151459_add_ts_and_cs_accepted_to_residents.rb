class AddTsAndCsAcceptedToResidents < ActiveRecord::Migration[5.0]
  def change
    add_column :residents, :ts_and_cs_accepted_at, :datetime
  end
end
