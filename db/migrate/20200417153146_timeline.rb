class Timeline < ActiveRecord::Migration[5.0]
  def change

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
      t.string :title
      t.string :question
      t.string :answer
      t.boolean :not_applicable, default: false
      t.text   :response
      t.string :positive, default: "Yes"
      t.string :negative, default: "No"
      t.timestamps
    end

    create_table :timeline_tasks do |t|
      t.references :timeline, foreign_key: true
      t.references :stage, foreign_key: true
      t.references :task, foreign_key: true
      t.boolean :head, default: false
      t.integer :next_id
    end

    create_table :plot_timelines do |t|
      t.references :timeline, foreign_key: true
      t.references :plot, foreign_key: true
      t.references :timeline_task, foreign_key: true
      t.boolean :complete, default: false
    end

    create_table :task_logs do |t|
      t.references :plot_timeline, foreign_key: true
      t.references :timeline_task, foreign_key: true
      t.integer :response
      t.timestamps
    end

    create_table :callouts do |t|
      t.references :task, foreign_key: true
      t.integer :callout_type
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

    create_table :timeline_shortcuts do |t|
      t.references :timeline, foreign_key: true
      t.references :shortcut, foreign_key: true
      t.integer :order
    end

    create_table :timeline_task_shortcuts do |t|
      t.references :timeline_task, foreign_key: true
      t.integer :shortcut_type
      t.boolean :live
    end

    # homeowner -------

    add_reference :plot_residencies, :timeline_task, foreign_key: true

  end
end
