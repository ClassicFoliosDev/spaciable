class CustomBuildProcess < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|
      direction.up {
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

        create_table :user_preferences do |t|
          t.references :user, null: false
          t.integer :preference, null: false
          t.boolean :on, default: false
          t.timestamps null: false
        end

        Rake::Task['build_progress:initialise'].invoke
      }

      direction.down {
        drop_table :build_sequences
        drop_table :build_steps
        drop_table :user_preferences
        remove_reference :plots, :build_step
      }
    end
  end
end
