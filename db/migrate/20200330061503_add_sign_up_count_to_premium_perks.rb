class AddSignUpCountToPremiumPerks < ActiveRecord::Migration[5.0]
  def change
    add_column :premium_perks, :sign_up_count, :integer, default: 0
  end
end
