class AddDivisionToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_reference :addresses, :developer, foreign_key: true
    add_reference :addresses, :division, foreign_key: true
  end
end
