# frozen_string_literal: true

# The TimeLine is a container for a list of Timeline_Tasks.
# A Timeline_Task is an ordered container for a Task.
# Tasks can be shared amongst different Timelines through Timeline_Tasks
# The Timeline has a set of associated stages e.g. Reservation,
# Exchange etc.
class Timeline < ApplicationRecord
  has_many :timeline_stages, -> { order "timeline_stages.order" }, dependent: :destroy
  has_many :stages, through: :timeline_stages
  has_many :timeline_tasks, dependent: :destroy
  has_many :timeline_shortcuts, -> { order "timeline_shortcuts.order" },
           inverse_of: :timeline, dependent: :destroy
  has_many :shortcuts, through: :timeline_shortcuts

  after_create :add_stages
  after_create :add_shortcuts

  # Retrieve a specific TimelineTask
  def ttask(task_id)
    TimelineTask.find(task_id)
  end

  # Get all TimelineTasks for this Timeline
  def ttasks
    TimelineTask.tasks(self, stages.first)
  end

  # Get all TimelineTasks for the Stage of this Timeline
  def stage_ttasks(stage)
    TimelineTask.tasks(self, stage, exclusive: true)
  end

  # Get all TimelineTasks for this Timeline.  Remember it is
  # possible that not all stages may be populated iterate through
  # until you find the head
  def head
    tasks = nil
    stages.each do |stage|
      tasks = TimelineTask.head(self, stage)
      break if tasks
    end
    tasks
  end

  # Get the tail (last) TimelineTask in this Timeline
  def tail
    TimelineTask.tail(self)
  end

  # Get the head (first) TimelineTask in the Stage of this Timeline
  def stage_head(stage_id)
    TimelineTask.head(self, stages.find(stage_id))
  end

  # get the task before
  def before(task)
    timeline_tasks.find_by(next_id: task.id)
  end

  # get the task after
  def after(task)
    timeline_tasks.find_by(id: task.next_id)
  end

  private

  def add_stages
    Stage.set.each_with_index do |stage, index|
      timeline_stages.create(timeline: self, stage: stage, order: index)
    end
  end

  def add_shortcuts
    Shortcut.list.each_with_index do |shortcut, index|
      timeline_shortcuts.create(timeline: self, shortcut: shortcut, order: index)
    end
  end

end
