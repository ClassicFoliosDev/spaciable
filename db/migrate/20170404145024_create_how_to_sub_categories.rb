class CreateHowToSubCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :how_to_sub_categories do |t|
      t.text :name
      t.text :parent_category

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
