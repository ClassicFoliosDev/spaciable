class TimelineStages < ActiveRecord::Migration[5.0]
  def change
    create_table :plot_timeline_stages do |t|
      t.references :plot_timeline, index: true
      t.references :timeline_stage, index: true
      t.boolean :collapsed, default: false
    end
  end
end
