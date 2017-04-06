class CreateJoinTableHowTosTags < ActiveRecord::Migration[5.0]
  def change
    create_join_table :how_tos, :tags do |t|
      t.index [:how_to_id, :tag_id], name: :how_to_tag_index
      t.index [:tag_id, :how_to_id], name: :tag_how_to_index
      t.timestamps
    end
  end
end
