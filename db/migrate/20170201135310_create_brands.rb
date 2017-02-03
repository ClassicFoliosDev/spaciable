class CreateBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :brands do |t|
      t.string :logo
      t.string :banner
      t.string :bg_color
      t.string :text_color
      t.string :content_bg_color
      t.string :content_text_color
      t.string :button_color
      t.string :button_text_color
      t.datetime :deleted_at
      t.timestamps

      t.references :brandable, polymorphic: true
    end
  end
end
