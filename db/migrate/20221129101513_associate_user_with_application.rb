class AssociateUserWithApplication < ActiveRecord::Migration[5.0]
  def change
  	add_reference :users, :oauth_applications, foreign_key: true
  end
end
