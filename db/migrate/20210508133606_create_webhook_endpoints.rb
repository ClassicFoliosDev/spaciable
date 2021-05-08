class CreateWebhookEndpoints < ActiveRecord::Migration[5.0]
  def change
    create_table :webhook_endpoints do |t|
      t.string :target_url, null: false
      t.timestamps
    end
  end
end
