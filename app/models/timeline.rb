# frozen_string_literal: true

# The TimeLine is a container for a list of Timeline_Tasks.
# A Timeline_Task is an ordered container for a Task.
# Tasks can be shared amongst different Timelines through Timeline_Tasks
# The Timeline has a set of associated stages e.g. Reservation,
# Exchange etc.
class Timeline < ApplicationRecord
  has_many :timeline_stages, -> { order "timeline_stages.order" }
  has_many :stages, through: :timeline_stages

  # Retrieve a specific Task
  def task(task_id)
    TimelineTask.find(task_id)
  end

  # Get all Tasks for this Timeline
  def tasks
    TimelineTask.tasks(self, stages.first)
  end

  # Get all Tasks for the Stage of this Timeline
  def stage_tasks(stage)
    TimelineTask.tasks(self, stage, exclusive: true)
  end

  # Get the head (first) Task in this Timeline
  def head
    TimelineTask.head(self, stages.first)
  end

  # Get the head (first) Task in the Stage of this Timeline
  def stage_head(stage_id)
    TimelineTask.head(self, stages.find(stage_id))
  end
end
