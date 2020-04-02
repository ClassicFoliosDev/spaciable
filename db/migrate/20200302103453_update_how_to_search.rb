class UpdateHowToSearch < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|
      # remove the search index on description and replace it with a search on title
      direction.up {
        remove_index :how_tos, name: "search_index_on_how_to_description"
        add_index :how_tos, 'lower(title) varchar_pattern_ops', name: "search_index_on_how_to_title"
      }
      # reinstate the search index on description and remove the one on title
      direction.down {
        remove_index :how_tos, name: "search_index_on_how_to_title"
        add_index :how_tos, 'lower(title) varchar_pattern_ops', name: "search_index_on_how_to_description"
      }
    end
  end
end
