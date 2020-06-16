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

  def progress_icon
    percent = task_logs.where(response: "positive").count.to_f / task_logs.count
    case percent
    when 0...0.1
      "igloo_2.svg"
    when 0.1...0.4
      "igloo_2.svg"
    when 0.4...0.7
      "igloo_3.svg"
    when 0.7...1
      "igloo_4.svg"
    when 1
      "igloo_comp.svg"
    end
  end
end
