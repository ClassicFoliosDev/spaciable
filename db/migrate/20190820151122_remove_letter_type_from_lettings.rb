class RemoveLetterTypeFromLettings < ActiveRecord::Migration[5.0]
  def change
    remove_column :lettings, :letter_type
  end
end
