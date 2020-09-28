class PhaseTimelines < ActiveRecord::Migration[5.0]
  def change
    reversible do |direction|
      direction.up {

        drop_table :task_logs
        drop_table :plot_timelines

        create_table :phase_timelines do |t|
          t.references :timeline, foreign_key: true
          t.references :phase, foreign_key: true
        end

        create_table   :plot_timelines do |t|
          t.references :phase_timeline, foreign_key: true
          t.references :plot, foreign_key: true
          t.references :task, foreign_key: true
          t.boolean :complete, default: false
        end

        create_table :task_logs do |t|
          t.references :plot_timeline, foreign_key: true
          t.references :task, foreign_key: true
          t.integer :response
          t.timestamps
        end

      }
      direction.down {
        drop_table :task_logs
        drop_table :plot_timelines
        drop_table :phase_timelines

        create_table :plot_timelines do |t|
          t.references :timeline, foreign_key: true
          t.references :plot, foreign_key: true
          t.references :task, foreign_key: true
          t.boolean :complete, default: false
        end

        create_table :task_logs do |t|
          t.references :plot_timeline, foreign_key: true
          t.references :task, foreign_key: true
          t.integer :response
          t.timestamps
        end
      }
    end
  end
end
