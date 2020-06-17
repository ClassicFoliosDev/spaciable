# frozen_string_literal: true

# A PlotTimeline assocates a Timeline with a Plot.
# A PlotTimeline records progress along a Timeline and
# homeowner responses via Task_Logs
class PlotTimeline < ApplicationRecord
  belongs_to :timeline, required: true
  belongs_to :plot, required: true
  belongs_to :task
  has_many :task_logs, dependent: :destroy

  delegate :live?, to: :timeline

  # Log non not_applicable responses for a Task.
  def log(task, response)
    log = task_logs.find_by(task_id: task.id) ||
          task_logs.create(task_id: task.id)
    log.update_attributes(response: response)
  end

  def complete?
    timeline.tasks.count ==
      task_logs.where(response: :positive).count
  end

  def progress_percent
    ((task_logs.where(response: "positive").count.to_f / task_logs.count) * 100).to_i
  end
end
