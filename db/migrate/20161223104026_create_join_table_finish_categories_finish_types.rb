class CreateJoinTableFinishCategoriesFinishTypes < ActiveRecord::Migration[5.0]
  def change
    create_join_table :finish_categories, :finish_types do |t|
      t.index [:finish_category_id, :finish_type_id], name: :finish_category_finish_type_index
      t.index [:finish_type_id, :finish_category_id], name: :finish_type_finish_category_index
      t.timestamps
    end
  end
end
