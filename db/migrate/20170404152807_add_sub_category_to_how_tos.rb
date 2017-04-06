class AddSubCategoryToHowTos < ActiveRecord::Migration[5.0]
  def change
    add_reference :how_tos, :how_to_sub_category, foreign_key: true
  end
end
