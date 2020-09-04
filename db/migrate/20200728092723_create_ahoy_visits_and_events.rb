class CreateAhoyVisitsAndEvents < ActiveRecord::Migration[5.0]
  def change
   reversible do |direction|

      direction.up {

        create_table :ahoy_visits do |t|
          t.string :visit_token
          t.string :visitor_token
          t.references :userable, polymorphic: true, index: true
          t.string :ip
          t.text :user_agent
          t.text :referrer
          t.string :referring_domain
          t.text :landing_page
          t.string :browser
          t.string :os
          t.string :device_type
          t.timestamp :started_at
        end

        add_index :ahoy_visits, [:visit_token], unique: true

        create_table :ahoy_events do |t|
          t.references :visit
          t.references :userable, polymorphic: true, index: true
          t.string :name
          t.integer :plot_id
          t.jsonb :properties
          t.timestamp :time
        end

        add_index :ahoy_events, [:name, :time]
        add_index :ahoy_events, "properties jsonb_path_ops", using: "gin"
      }

      direction.down {

        remove_index :ahoy_events, name: "index_ahoy_events_on_name_and_time"
        remove_index :ahoy_visits, name: "index_ahoy_events_on_properties_jsonb_path_ops"

        drop_table :ahoy_visits
        drop_table :ahoy_events
      }
    end
  end
end
