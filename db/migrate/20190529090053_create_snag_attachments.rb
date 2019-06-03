class CreateSnagAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :snag_attachments do |t|
      t.integer :snag_id
      t.string :image

      t.timestamps
    end
  end
end
