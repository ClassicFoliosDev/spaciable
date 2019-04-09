class CreateReferrals < ActiveRecord::Migration[5.0]
  def change
    create_table :referrals do |t|
      t.string :referrer_name
      t.string :referrer_email
      t.string :referrer_developer
      t.string :referrer_address

      t.string :referee_first_name
      t.string :referee_last_name
      t.string :referee_email
      t.string :referee_phone

      t.datetime :referral_date
      t.boolean :email_confirmed, default: false
      t.string :confirm_token

      t.timestamps
    end
  end
end
