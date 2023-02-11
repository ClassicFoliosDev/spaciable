class ChartColours < ActiveRecord::Migration[5.0]
  def change
    create_table :chart_colours do |t|
      t.integer :key, default: ChartColour.keys[:unassigned]
      t.string :colour, default: "#ffffff"
    end

    Rake::Task['chart_colours:initialise'].invoke
  end
end
