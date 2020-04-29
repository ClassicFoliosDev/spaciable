class AddTimeline < ActiveRecord::Migration[5.0]
  def up

    # admin --------

    create_table :timelines do |t|
      t.string :title
      t.timestamps
    end

    create_table :stages do |t|
      t.string :title
      t.text :description
      t.timestamps
    end

    create_table :timeline_stages do |t|
      t.references :timeline, foreign_key: true
      t.references :stage, foreign_key: true
      t.integer :order
    end

    create_table :tasks do |t|
      t.references :timeline, foreign_key: true
      t.references :stage, foreign_key: true
      t.string :title
      t.string :question
      t.string :answer
      t.boolean :not_applicable, default: false
      t.text   :response
      t.string :positive, default: "Yes"
      t.string :negative, default: "No"
      t.boolean :head, default: false
      t.integer :next_id
      t.timestamps
    end

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

    create_table :actions do |t|
      t.references :task, foreign_key: true
      t.string :title
      t.text :description
      t.string :link
    end

    create_table :features do |t|
      t.references :task, foreign_key: true
      t.string :title
      t.text :description
      t.string :link
    end

    create_table :shortcuts do |t|
      t.integer :shortcut_type
      t.string  :icon
      t.string  :link
      t.timestamps
    end

    create_table :task_shortcuts do |t|
      t.references :task, foreign_key: true
      t.references :shortcut, foreign_key: true
      t.integer :order
      t.boolean :live
    end

    # homeowner -------

    add_reference :plot_residencies, :task, foreign_key: true

  end

  def down
    remove_reference :plot_residencies, :timeline_task, index: true, foreign_key: true
    remove_reference :callouts, :task, index: true, foreign_key: true
    remove_reference :plot_timelines, :plot, index: true, foreign_key: true
    remove_reference :plot_timelines, :timeline, index: true, foreign_key: true
    remove_reference :plot_timelines, :timeline_task, index: true, foreign_key: true
    remove_reference :task_logs, :plot_timeline, index: true, foreign_key: true
    remove_reference :task_logs, :timeline_task, index: true, foreign_key: true
    remove_reference :timeline_shortcuts, :shortcut, index: true, foreign_key: true
    remove_reference :timeline_shortcuts, :timeline, index: true, foreign_key: true
    remove_reference :timeline_stages, :stage, index: true, foreign_key: true
    remove_reference :timeline_stages, :timeline, index: true, foreign_key: true
    remove_reference :timeline_task_shortcuts, :timeline_task, index: true, foreign_key: true
    remove_reference :timeline_tasks, :stage, index: true, foreign_key: true
    remove_reference :timeline_tasks, :task, index: true, foreign_key: true
    remove_reference :timeline_tasks, :timeline, index: true, foreign_key: true

    drop_table :timelines
    drop_table :tasks
    drop_table :stages
    drop_table :shortcuts
    drop_table :callouts
    drop_table :timeline_stages
    drop_table :timeline_tasks
    drop_table :timeline_task_shortcuts
    drop_table :timeline_shortcuts
    drop_table :task_logs
    drop_table :plot_timelines
  end
end
