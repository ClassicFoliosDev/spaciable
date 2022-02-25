class EnergyRatings < ActiveRecord::Migration[5.0]
  def change
    add_column :appliances, :main_uk_e_rating, :integer
    add_column :appliances, :supp_uk_e_rating, :integer
  end
end
