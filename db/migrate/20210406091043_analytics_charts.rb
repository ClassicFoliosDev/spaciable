class AnalyticsCharts < ActiveRecord::Migration[5.0]
  def change
    create_table :charts do |t|
      t.references :chartable, polymorphic: true, index: true
      t.integer :section
      t.boolean :enabled
    end

    Developer.all.each do |d|
      Chart.sections.each { |s,_| Chart.create(chartable: d, section:s, enabled: true) }
    end

    add_column :users, :selections, :string, default: nil
    add_column :developers, :analytics_dashboard, :boolean, default: true
    add_column :divisions, :analytics_dashboard, :boolean, default: true
    add_column :developments, :analytics_dashboard, :boolean, default: true
  end
end
