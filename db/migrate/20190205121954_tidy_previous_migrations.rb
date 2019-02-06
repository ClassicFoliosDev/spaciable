class TidyPreviousMigrations < ActiveRecord::Migration[5.0]
  def change
    drop_table :countries
    remove_column :how_tos, :country_id
    remove_column :default_faqs, :country_id
    remove_column :developers, :country_id
  end
end
