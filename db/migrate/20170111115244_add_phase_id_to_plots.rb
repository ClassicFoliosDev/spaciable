class AddPhaseIdToPlots < ActiveRecord::Migration[5.0]
  def change
    add_reference :plots, :phase, foreign_key: true, index: true
  end
end
