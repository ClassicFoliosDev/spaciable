class Timeline < ActiveRecord::Migration[5.0]
  def change

    # admin --------

    create_table :globals do |t|
      t.string :name
    end

    create_table :timelines do |t|
      t.string :title
      t.references :timelineable, polymorphic: true, index: true
      t.timestamps
    end

    create_table :stages do |t|
      t.string :title
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
      t.string :picture
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

    create_table :finales do |t|
      t.references :timeline, foreign_key: true
      t.string :complete_picture
      t.text :complete_message
      t.string :incomplete_picture
      t.text :incomplete_message
    end

    create_table :task_contacts do |t|
      t.references :task, foreign_key: true
      t.integer :contact_type
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

    # admin -----------

    add_column :contacts, :contact_type, :integer, default: 0
    add_column :developers, :timeline, :boolean, default: false

    add_reference :divisions, :timeline, foreign_key: true
    add_reference :developments, :timeline, foreign_key: true

    # homeowner -------

    add_reference :plot_residencies, :task, foreign_key: true

    # Data --

    load Rails.root.join("db/seeds", "timeline.rb")
  end
end
