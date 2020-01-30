class CreateBrandedApp < ActiveRecord::Migration[5.0]
  def change
    create_table :branded_apps do |t|
      t.references :app_owner, polymorphic: true
      t.string :android_link
      t.string :apple_link
      t.string :app_icon
    end
  end
end
