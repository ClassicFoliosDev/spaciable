class EnergyRatings < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|

      direction.up {

        add_column :appliances, :main_uk_e_rating, :integer
        add_column :appliances, :supp_uk_e_rating, :integer

        Rake::Task['ratings:migrate'].invoke
      }

      direction.down {
        remove_column :appliances, :main_uk_e_rating
        remove_column :appliances, :supp_uk_e_rating
      }
    end
  end
end
