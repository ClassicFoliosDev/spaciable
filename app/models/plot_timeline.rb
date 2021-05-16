# frozen_string_literal: true

# A PlotTimeline assocates a Timeline with a Plot.
# A PlotTimeline records progress along a Timeline and
# homeowner responses via Task_Logs
class PlotTimeline < ApplicationRecord
  belongs_to :phase_timeline, required: true
  belongs_to :plot, required: true
  belongs_to :task
  has_many :task_logs, dependent: :destroy

  delegate :live?, :timeline, :timeline_title, :stage_set, to: :phase_timeline

  scope :matching,
        lambda { |plot, timeline|
          joins(:phase_timeline)
            .where(plot: plot)
            .where(phase_timelines: { timeline_id: timeline.id })
        }

  # Log non not_applicable responses for a Task.
  def log(task, response)
    return if response == :not_applicable

    log = task_logs.find_by(task_id: task.id) ||
          task_logs.create(task_id: task.id)
    # only record if response is forward
    if log.response.nil? ||
       TaskLog.responses[response.to_s] < TaskLog.responses[log.response]
      log.update_attributes(response: response)
    end
  end

  def complete?
    timeline.tasks.count ==
      task_logs.where(response: :positive).count
  end

  def progress_percent
    return 0 unless timeline.tasks.count.positive?
    ((task_logs.where(response: "positive").count.to_f / timeline.tasks.count) * 100).to_i
  end

  # Reset to the start
  def reset
    task_logs.destroy
    self.task_id = nil
    self.complete = false
    save
  end
end
