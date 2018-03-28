class AddOriginalFilenameToFinishes < ActiveRecord::Migration[5.0]
  def change
    add_column :finishes, :original_filename, :string
  end
end
