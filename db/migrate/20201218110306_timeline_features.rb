class TimelineFeatures < ActiveRecord::Migration[5.0]
  def change
    add_column :features, :feature_type, :integer, default: 0
  end
end
