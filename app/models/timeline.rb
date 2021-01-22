# frozen_string_literal: true

# The TimeLine is a container for a list of Timeline_Tasks.
# A Timeline_Task is an ordered container for a Task.
# Tasks can be shared amongst different Timelines through Timeline_Tasks
# The Timeline has a set of associated stages e.g. Reservation,
# Exchange etc.
# rubocop:disable Metrics/ClassLength
class Timeline < ApplicationRecord
  belongs_to :timelineable, polymorphic: true
  has_many :phase_timelines, dependent: :destroy
  has_one :finale, dependent: :destroy
  has_many :tasks, dependent: :destroy
  belongs_to :stage_set
  delegate :stages, :stage_set_type, to: :stage_set

  delegate :complete_message, :complete_picture,
           :incomplete_message, :incomplete_picture, to: :finale

  amoeba do
    include_association :finale
    # tasks have to be duplicated manually as they are a linked list
  end

  validates :title,
            presence: true,
            uniqueness:
            {
              scope: %i[timelineable],
              case_sensitive: false
            }

  scope :in_phase,
        lambda { |phase|
          joins(phase_timelines: { plot_timelines: :plot })
            .where(plots: { phase_id: phase.id }).distinct
        }

  scope :not_used_in_phase,
        lambda { |phase|
          available = where(timelineable_type: "Global").or(where(timelineable: phase.developer))
          available.where.not(id: in_phase(phase))
        }

  # Retrieve a specific Task
  def task(task_id)
    Task.find(task_id)
  end

  # Get all Tasks for this Timeline
  def tasks
    Task.tasks(self, head&.stage || stages.first)
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

  # rubocop:disable Metrics/MethodLength
  def clone
    new_timeline = error = nil
    Timeline.transaction do
      begin
        new_timeline = amoeba_dup
        new_timeline.title += " (copy)"
        new_timeline.save!

        # The tasks are a linked list - with ids to the next
        # task.  A normal clone would copy all the next_ids and
        # link to the records of the donor, so we have to go through
        # and link the new cloned tasks together manually
        prev_task = nil
        tasks&.each do |task|
          new_task = task.amoeba_dup # duplicate the task
          new_task.timeline = new_timeline # assign the timeline
          new_task.save! # save it
          # link previous task to new task
          prev_task&.update_attributes!(next_id: new_task.id)
          prev_task = new_task
        end
      rescue ActiveRecord::RecordInvalid => e
        error = e.message
        raise ActiveRecord::Rollback
      end
    end
    yield new_timeline, error
  end
  # rubocop:enable Metrics/MethodLength

  def to_s
    title
  end

  def live?
    # Are there any tasks and a finale?  Use a
    # quick an efficient Task query
    finale && Task.find_by(timeline_id: id)
  end

  def supports?(feature)
    timelineable.is_a?(Global) || timelineable.supports?(feature)
  end

  # remove all the tasks for a stage
  def remove_stage(stage)
    stage_tasks(stage)&.each(&:remove)
  end

  def change_stage(old_stage, new_stage)
    return if old_stage.id == new_stage.id
    stage_tasks(old_stage)&.each { |t| t.update_attributes(stage: new_stage) }
  end

  # Go through the stages and make sure all are connected in the right order
  def refactor
    prev_task = nil
    stages.each do |stage|
      tasks = stage_tasks(stage)
      next unless tasks

      prev_task&.update_attributes(next_id: tasks.first.id)
      prev_task = tasks.last
    end

    prev_task&.update_attributes(next_id: nil)
  end
end
# rubocop:enable Metrics/ClassLength
