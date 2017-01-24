class CreateResidentNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :resident_notifications do |t|
      t.belongs_to :resident, foreign_key: false
      t.belongs_to :notification, foreign_key: true

      t.timestamps
    end
  end
end
