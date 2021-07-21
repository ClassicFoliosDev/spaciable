class CustomBuildProcess < ActiveRecord::Migration[5.0]
  def change
    create_table :build_sequences do |t|
      t.references :build_sequenceable, polymorphic: true, index: false
      t.timestamps null: false
    end

    create_table :build_steps do |t|
      t.references :build_sequence, null: false
      t.string :title, null: false
      t.string :description, null: false
      t.integer :order, null: false
      t.timestamps null: false
    end

    add_reference :plots, :build_step

    Rake::Task['build_progress:initialise'].invoke
  end
end
