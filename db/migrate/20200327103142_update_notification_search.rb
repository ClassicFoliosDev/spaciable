class UpdateNotificationSearch < ActiveRecord::Migration[5.0]
def change
    reversible do |direction|
      # remove the search index on message
      direction.up {
        remove_index :notifications, name: "search_index_on_notification_message"
      }
      # reinstate the search index on message
      direction.down {
        add_index :notifications, 'lower(message) varchar_pattern_ops', name: "search_index_on_notification_message"
      }
    end
  end
end
