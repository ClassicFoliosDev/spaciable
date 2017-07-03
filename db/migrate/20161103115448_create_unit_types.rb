class CreateUnitTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :unit_types do |t|
      t.string :name
      t.belongs_to :phase, foreign_key: true

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
