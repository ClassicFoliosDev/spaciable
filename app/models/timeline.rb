# frozen_string_literal: true

# The TimeLine is a container for a list of Timeline_Tasks.
# A Timeline_Task is an ordered container for a Task.
# Tasks can be shared amongst different Timelines through Timeline_Tasks
# The Timeline has a set of associated stages e.g. Reservation,
# Exchange etc.
class Timeline < ApplicationRecord
  has_many :timeline_stages, -> { order "timeline_stages.order" }, dependent: :destroy
  has_many :stages, through: :timeline_stages
  has_many :tasks, dependent: :destroy

  after_create :add_stages

  amoeba do
    include_association :timeline_stages
  end

  # Retrieve a specific Task
  def task(task_id)
    Task.find(task_id)
  end

  # Get all Tasks for this Timeline
  def tasks
    Task.tasks(self, stages.first)
  end

  # Get all Tasks for the Stage of this Timeline
  def stage_tasks(stage)
    Task.tasks(self, stage, exclusive: true)
  end

  # Get all Tasks for this Timeline.  Remember it is
  # possible that not all stages may be populated iterate through
  # until you find the head
  def head
    tasks = nil
    stages.each do |stage|
      tasks = Task.head(self, stage)
      break if tasks
    end
    tasks
  end

  # Get the tail (last) Task in this Timeline
  def tail
    Task.tail(self)
  end

  # Get the head (first) Task in the Stage of this Timeline
  def stage_head(stage_id)
    Task.head(self, stages.find(stage_id))
  end

  # get the task before
  def before(task)
    Task.find_by(next_id: task.id)
  end

  # get the task after
  def after(task)
    Task.find_by(id: task.next_id)
  end

  def clone
    new_timeline = amoeba_dup
    new_timeline.title = CloneNameService.call(title)
    new_timeline
  end

  def to_s
    title
  end

  private

  def add_stages
    return unless timeline_stages.empty?

    Stage.set.each_with_index do |stage, index|
      timeline_stages.create(timeline: self, stage: stage, order: index)
    end
  end
end
