# frozen_string_literal: true

namespace :task_images do
  task migrate: :environment do
    migrate
  end

  def migrate
    Task.all.each do |task|
      next unless task.picture?
      task.update_attribute(:media_type, Task.media_types[:image])
    end
  end
end
