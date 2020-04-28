# frozen_string_literal: true

# The TimelineTask is the ordered container for Tasks.  Timeline_Tasks
# are linked together in a list through their 'next' attribute.  The
# 'Head' attribute indicates the TimelineTask is the first in the list
# for the associated Stage
class TimelineTask < ApplicationRecord
  belongs_to :timeline, optional: false
  belongs_to :stage, optional: false
  belongs_to :task, optional: false
  belongs_to :next, class_name: "TimelineTask", foreign_key: "next_id"
  has_many :timeline_task_shortcuts, dependent: :destroy

  delegate :title, to: :task
  delegate :question, to: :task
  delegate :answer, to: :task
  delegate :not_applicable, to: :task
  delegate :response, to: :task
  delegate :positive, to: :task
  delegate :negative, to: :task
  delegate :actions, to: :task
  delegate :features, to: :task
  delegate :action, to: :task
  delegate :feature, to: :task

  # Get the task at the head of the specified stage
  def self.head(timeline, stage)
    find_by(timeline_id: timeline.id, stage_id: stage.id, head: true)
  end

  # Get the task at the tail
  def self.tail(timeline)
    find_by(timeline_id: timeline.id, next_id: nil)
  end

  # Retrive the list of tasks for the timeline, starting at the head of
  # the specified stage
  def self.tasks(timeline, stage, exclusive: false)
    # form the recursive query
    tasks_query = task_list(timeline, stage, exclusive)
    # execute the query to get the ids of the timeline  tasks in list order
    tasks = ActiveRecord::Base.connection.execute(tasks_query).values
    return nil if tasks.blank?

    tasks = tasks.flatten.join(",")

    # retrieve the timeline tasks in the order retreieved by the
    # recursive query .. i.e. 'list order'
    where("#{table_name}.id IN (#{tasks})")
      .order("array_position(array[#{tasks}], #{table_name}.id)")
  end

  # The timeline tasks are held in a linked list.  Each timeline task
  # has a next_id.  The timeline tasks are linked from beginning to end
  # through all the stages, exactly as they are inteded to be presented
  # to the homeowner.  The SQL to retrieve the timeline tasks has to be
  # recursive. Recursion follows the list until the next_id is null. In
  # the case of 'exclusive' searches, the recursion will stop as soon as
  # a timeline task for a different stage is met.  This is not simple
  # to understand so I suggest reading further before changiging this
  #
  # The results of this query will be in 'list order'
  def self.task_list(instance, stage, exclusive = false)
    where_stage = " AND #{table_name}.stage_id = #{stage.id} " if exclusive
    <<-SQL
      WITH RECURSIVE task_list(id, next_id, N) AS (
          SELECT id, next_id, 1
          FROM #{table_name}
          WHERE timeline_id = #{instance.id} AND
                stage_id = #{stage.id} AND
                head IS TRUE
        UNION ALL
          SELECT #{table_name}.id, #{table_name}.next_id, N+1
          FROM task_list
          JOIN #{table_name} ON #{table_name}.id = task_list.next_id #{where_stage}
      )
      SELECT id FROM task_list ORDER BY N
    SQL
  end

  def update_from?(params)
    TimelineTask.transaction do
      task.update_from(params)
      update_shortcuts(params)
      self.update_attributes(stage_id: params[:stage][:option])
      reset_head
      timeline.after(self)&.reset_head
      true
    end
  end

  def self.create_with(params, timeline, prev, after)
    TimelineTask.transaction do
      timeline_task =
        TimelineTask.new(timeline: timeline,
                         task: Task.create(params[:task]),
                         stage_id: params[:stage][:option],
                         next_id: after&.id)
      timeline_task.save
      timeline_task.create_shortcuts(params)
      prev&.update_attributes(next_id: timeline_task.id)
      timeline_task.reset_head
      after&.reset_head
      timeline_task
    end
  end

  def remove
    TimelineTask.transaction do
      # link prev to following timeline_task
      prev = TimelineTask.find_by(next_id: id) # get prev
      following = TimelineTask.find_by(id: next_id) # and next
      # set prev->next to following
      prev&.update_attributes(next_id: following&.id)
      # set following->head true if the stages change between tasks
      following&.update_attributes(
        head: prev.blank? || prev.stage != following&.stage)

      # destroy any logs for this task
      TaskLog.where(timeline_task_id: id).destroy_all

      # update any PlotTimeline referencing this TimelineTask
      PlotTimeline.where(timeline_task_id: id)
                  .update_all(timeline_task_id: following&.id || prev&.id)

      #finally destroy the TimelineTask
      destroy
    end
  end

  def reset_head
    prev = timeline.before(self)
    update_attributes(head: prev.blank? || prev.stage != self.stage)
  end

  def update_shortcuts(params)
    scuts = params[:shortcuts]
    timeline_task_shortcuts.each do |ts|
      if (scuts[ts.shortcut_type])
        ts.update_attributes(live: scuts[ts.shortcut_type])
      end
    end
  end

  def create_shortcuts(params)
    scuts = params[:shortcuts]
    timeline.shortcuts.each do |ts|
      if (scuts[ts.shortcut_type])
        timeline_task_shortcuts.create(shortcut_type: ts.shortcut_type,
                                       live: scuts[ts.shortcut_type])
      end
    end
  end

end
