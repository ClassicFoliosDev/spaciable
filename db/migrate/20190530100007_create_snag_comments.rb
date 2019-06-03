class CreateSnagComments < ActiveRecord::Migration[5.0]
  def change
    create_table :snag_comments do |t|
      t.string :content
      t.string :image

      t.references :snag, foreign_key: true
      t.references :commenter, polymorphic: true

      t.timestamps
    end
  end
end
