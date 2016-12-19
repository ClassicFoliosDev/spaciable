class AddUpdatedAtToDivisions < ActiveRecord::Migration[5.0]
  def change
    add_column(:divisions, :created_at, :datetime)
    add_column(:divisions, :updated_at, :datetime)

    add_index :divisions, :created_at
    add_index :divisions, :updated_at
  end
end
