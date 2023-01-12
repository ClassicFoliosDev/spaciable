class MyJourneyVideo < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :media_type, :integer, default: Task.media_types[:no_media]
    add_column :tasks, :video_title, :string
    add_column :tasks, :video_link, :string

    Rake::Task['task_images:migrate'].invoke
  end
end
