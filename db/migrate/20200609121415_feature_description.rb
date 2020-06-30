class FeatureDescription < ActiveRecord::Migration[5.0]
  def change
    add_column :features, :precis, :string

    create_table :lookups do |t|
      t.string :code
      t.string :column
      t.string :translation
    end

    # Data --
    load Rails.root.join("db/seeds", "lookups.rb")
  end
end
