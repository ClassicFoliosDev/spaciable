class Robertson < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {
        add_column :documents, :lau_visible, :boolean, default: false
        Rake::Task['robertson:initialise'].invoke unless Rails.env.test?
      }

      direction.down {
        remove_column :documents, :lau_visible
      }
    end
  end
end
