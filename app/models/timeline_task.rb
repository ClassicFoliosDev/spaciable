# frozen_string_literal: true

# The TimelineTask is the ordered container for Tasks.  Timeline_Tasks
# are linked together in a list through their 'next' attribute.  The
# 'Head' attribute indicates the TimelineTask is the first in the list
# for the associated Stage
class TimelineTask < ApplicationRecord
  include ActionTypeEnum

  belongs_to :timeline, optional: false
  belongs_to :stage, optional: false
  belongs_to :task, optional: false
  belongs_to :next, class_name: "TimelineTask", foreign_key: "next_id"

  delegate :title, to: :task
  delegate :question, to: :task
  delegate :answer, to: :task
  delegate :not_applicable, to: :task
  delegate :response, to: :task
  delegate :positive, to: :task
  delegate :negative, to: :task
  delegate :shortcuts, to: :task

  # Get the task at the head of the specified stage
  def self.head(timeline, stage)
    find_by(timeline_id: timeline.id, stage_id: stage.id, head: true)
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

  # Get the :action actions
  def actions
    task.actions.where(action_type: :action)
  end

  # Get the :feature actions
  def features
    task.actions.where(action_type: :feature)
  end
end
