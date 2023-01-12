# frozen_string_literal: true

module TaskHelper
  # Get the how_to categories for the country
  def task_media_collection
    Task.media_types.map do |(media_name, _media_int)|
      [t(media_name, scope: task_media_scope), media_name]
    end
  end

  private

  def task_media_scope
    "activerecord.attributes.task.media_type"
  end
end
