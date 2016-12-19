class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :postal_name
      t.string :city
      t.string :county
      t.string :postcode

      t.timestamps
    end
  end
end
