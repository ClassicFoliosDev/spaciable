class AddReferralsToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :enable_referrals, :boolean, default: false
  end
end
