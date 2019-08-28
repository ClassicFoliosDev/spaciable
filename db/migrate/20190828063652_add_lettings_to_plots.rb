class AddLettingsToPlots < ActiveRecord::Migration[5.0]
  def change
    add_column :plots, :letable, :boolean, default: false
    add_column :plots, :let, :boolean, default: false
    add_column :plots, :letable_type, :integer
    add_column :plots, :letter_type, :integer
  end
end
