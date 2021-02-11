class ActionFeatures < ActiveRecord::Migration[5.0]
  def change
    add_column :actions, :feature_type, :integer, default: 0
  end
end
