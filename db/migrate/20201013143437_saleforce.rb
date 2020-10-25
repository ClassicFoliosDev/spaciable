class Saleforce < ActiveRecord::Migration[5.0]

  def change
   reversible do |direction|

      direction.up {
        add_reference :access_tokens, :crm, foreign_key: true
        Rake::Task['saleforce:initialise'].invoke unless Rails.env.test?
      }

      direction.down {
        remove_reference :access_tokens, :crm, index: true
      }
    end
  end

end
