class CustomBuildProcess < ActiveRecord::Migration[5.0]
  def change
    create_table :build_sequences do |t|
      t.boolean :master, default: false
      t.timestamps null: false
    end

    create_table :build_steps do |t|
      t.references :build_sequence,     null: false
      t.string :title, null: false
      t.string :description, null: false
      t.integer :order, null: false
      t.timestamps null: false
    end

    add_reference :developers, :build_sequence, foreign_key: true
    add_reference :divisions, :build_sequence, foreign_key: true

    Rake::Task['build_progress:initialise'].invoke unless Rails.env.test?
  end
end
