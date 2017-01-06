class AddFinishCategoryToFinishes < ActiveRecord::Migration[5.0]
  def change
    add_reference :finishes, :finish_category, foreign_key: true
    add_reference :finishes, :finish_type, foreign_key: true
    add_reference :finishes, :manufacturer, foreign_key: true
  end
end
