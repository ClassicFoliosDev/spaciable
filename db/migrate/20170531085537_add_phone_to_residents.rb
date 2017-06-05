class AddPhoneToResidents < ActiveRecord::Migration[5.0]
  def change
    add_column :residents, :phone_number, :string
  end
end
