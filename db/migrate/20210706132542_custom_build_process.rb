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
    add_reference :developers, :build_sequenceable, polymorphic: true, index: { name: 'developer_build_seq' }
    add_reference :divisions, :build_sequenceable, polymorphic: true, index: { name: 'division_build_seq' }

    Rake::Task['build_progress:initialise'].invoke unless Rails.env.test?
  end
end
