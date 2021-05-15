class CreateWebhookEndpoints < ActiveRecord::Migration[5.0]
  def change
    create_table :webhook_endpoints do |t|
      t.string :target_url, null: false
      t.string :sources, null: false, array: true
      t.timestamps
      t.index :sources
    end
  end
end
