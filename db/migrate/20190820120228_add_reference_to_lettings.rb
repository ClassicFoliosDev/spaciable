class AddReferenceToLettings < ActiveRecord::Migration[5.0]
  def change
    add_reference :lettings, :lettings_account, foreign_key: true
  end
end
