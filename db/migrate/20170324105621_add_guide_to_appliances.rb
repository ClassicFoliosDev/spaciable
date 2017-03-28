class AddGuideToAppliances < ActiveRecord::Migration[5.0]
  def change
    add_column :appliances, :guide, :string
  end
end
