# frozen_string_literal: true

module StageSetHelper
  def display_section(timeline)
    timeline.stage_set.journey? ? "answer" : "proforma"
  end

  def skip_direction(task)
    task.stage_set.journey? ? :forward : :back
  end

  def skip_action(task)
    task.stage_set.journey? ? :skipped_on_content : :completed_on_content
  end

  def skip_response(task)
    task.stage_set.journey? ? :negative : :positive
  end
end
