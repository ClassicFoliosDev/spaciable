class AddLetterToDeveloper < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :lettings_email, :string
    add_column :developers, :lettings_first_name, :string
    add_column :developers, :lettings_last_name, :string
  end
end
