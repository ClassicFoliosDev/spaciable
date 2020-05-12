# frozen_string_literal: true

# The Task is the ordered container for Tasks.  Timeline_Tasks
# are linked together in a list through their 'next' attribute.  The
# 'Head' attribute indicates the Task is the first in the list
# for the associated Stage
# rubocop:disable Metrics/ClassLength
class Task < ApplicationRecord
  mount_uploader :picture, PictureUploader
  attr_accessor :picture_cache

  belongs_to :timeline, optional: false
  belongs_to :stage, optional: false

  belongs_to :next, class_name: "Task", foreign_key: "next_id"
  has_many :task_shortcuts, -> { order "task_shortcuts.order" }, dependent: :destroy
  accepts_nested_attributes_for :task_shortcuts
  has_many :shortcuts, through: :task_shortcuts
  has_many :task_contacts, dependent: :destroy
  accepts_nested_attributes_for :task_contacts, reject_if: :all_blank, allow_destroy: true

  has_one :action, required: false, dependent: :destroy
  accepts_nested_attributes_for :action, reject_if: :all_blank, allow_destroy: true
  has_one :feature, required: false, dependent: :destroy
  accepts_nested_attributes_for :feature, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
  validates :question, presence: true
  validates :answer, presence: true
  validates :positive, presence: true
  validates :negative, presence: true
  validates :stage_id, presence: true

  delegate :title, to: :stage, prefix: true
  delegate :description, :link, :title, to: :feature, prefix: true
  delegate :description, :link, :title, to: :action, prefix: true

  amoeba do
    include_association :task_shortcuts
    include_association :action
    include_association :feature
    include_association :task_contacts

    customize(lambda { |original_task, new_task|
      if original_task.picture.present?
        CopyCarrierwaveFile::CopyFileService
          .new(original_task, new_task, :picture).set_file
      end
    })
  end

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

  # rubocop:disable SkipsModelValidations
  def remove
    Task.transaction do
      # link prev to following timeline_task
      prev = Task.find_by(next_id: id) # get prev
      following = Task.find_by(id: next_id) # and next
      # set prev->next to following
      prev&.update_attributes(next_id: following&.id)
      # set following->head true if the stages change between tasks
      following&.update_attributes(
        head: prev.blank? || prev.stage != following&.stage)

      # destroy any logs for this task
      TaskLog.where(task_id: id).destroy_all

      # update any PlotTimeline referencing this Task
      PlotTimeline.where(task_id: id)
                  .update_all(task_id: following&.id || prev&.id)
      # finally destroy the Task
      destroy
    end
  end
  # rubocop:enable SkipsModelValidations

  # Reset the head true/false based on previous task
  def reset_head
    prev = timeline.before(self)
    update_attributes(head: prev.blank? || prev.stage != stage)
  end

  # Get the tasks contact types as integers
  def contact_types
    task_contacts&.pluck(:contact_type)&.map { |ct| Contact.contact_types[ct] }
  end

  # Get all the contacts relevant to the plot
  def contacts(plot)
    types = contact_types
    return nil if types.empty?

    Contact.of_types(plot, types)
  end

  # build the dependent associations for a Task
  def build
    build_action unless action
    build_feature unless feature

    if task_shortcuts.empty?
      Shortcut.list.each_with_index do |s, index|
        task_shortcuts.build(shortcut: s, order: index, live: true)
      end
    end

    # max 2 task_contacts
    (0..1).each { |i| task_contacts.build unless task_contacts[i] }
  end
end
# rubocop:enable Metrics/ClassLength
