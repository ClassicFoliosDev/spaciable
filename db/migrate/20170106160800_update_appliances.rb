class UpdateAppliances < ActiveRecord::Migration[5.0]
  def change
    add_column :appliances, :description, :string
    add_column :appliances, :secondary_image, :string
    add_column :appliances, :document, :string

    remove_column :appliances, :images
    remove_column :appliances, :manufacturer
    remove_column :appliances, :category

  end
end
