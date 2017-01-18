class AddDevelopmentIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :development, foreign_key: true, index: true
  end
end
