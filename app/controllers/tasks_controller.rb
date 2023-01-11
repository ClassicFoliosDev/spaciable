# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class TasksController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :timeline
  load_and_authorize_resource :task, except: %i[show_timeline]

  before_action do
    @stages = @timeline.stages.select(:title).order(:id).pluck(:id, :title)
  end

  def new
    @insert_mode = params[:insert].to_sym # insert first/before/after
    # task being inserted before/after
    @insertion_task = params[:task_id] ? Task.find(params[:task_id]) : nil

    create_new
  end

  def empty
    # render an empty timeline
    render :show
  end

  def show
    @disabled_stages = @timeline.stages.pluck(:id)
    @checked_stage = @task&.stage_id
  end

  def edit
    @disabled_stages = disabled_stages(@task)
    @checked_stage = @task&.stage_id
    @task.build
  end

  def update
    if @task.update(task_params)
      @task.reset_head
      @task&.next&.reset_head
      redirect_to timeline_task_path, notice: t("controller.success.update", name: @task.title)
    else
      create_new
      render :edit
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def create
    # Get the tasks before and after
    case donor_params[:donor][:mode].to_sym
    when :before
      after = Task.find_by(id: donor_params[:donor][:task_id])
      prev = @timeline.before(after)
    when :after
      prev = Task.find_by(id: donor_params[:donor][:task_id])
      after = @timeline.after(prev)
    end

    if @task.save
      # update the surrounding tasks
      @task.update_attributes(next_id: after&.id)
      prev&.update_attributes(next_id: @task.id)
      @task.reset_head
      after&.reset_head

      redirect_to [@timeline, @task], notice: t("controller.success.create", name: @task.title)
    else
      @insert_mode = donor_params[:donor][:mode]
      @insertion_task = Task.find_by(id: donor_params[:donor][:task_id])
      create_new
      render :new
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def destroy
    @task.remove
    notice = t(".success", name: @task.title)
    redirect_to [@timeline, (@task.next || @timeline.tail)], notice: notice
  end

  private

  # When editing or adding a task, only particular stages can be selected
  # based on the previous and next
  # rubocop:disable Metrics/MethodLength
  def disabled_stages(task, position: :at)
    case position
    when :first
      prev = after = nil
    when :at
      prev = @timeline.before(task)
      after = @timeline.after(task)
    when :before
      prev = @timeline.before(task)
      after = task
    when :after
      prev = task
      after = @timeline.after(task)
    end

    enabled_stages = []
    started = false
    @timeline.stages.each do |stage|
      started ||= prev.blank? || prev.stage == stage
      enabled_stages << stage.id if started
      break if after&.stage == stage
    end

    @timeline.stages.pluck(:id) - enabled_stages
  end
  # rubocop:enable Metrics/MethodLength

  def task_params
    params.require(:task).permit(
      :stage_id, :timeline_id, :picture,
      :title, :title_class, :question, :answer, :response, :positive,
      :negative, :not_applicable, :remove_picture, :picture_cache,
      :media_type, :video_title, :video_link,
      features_attributes: %i[id title precis description feature_type link _destroy],
      action_attributes: %i[id title feature_type link _destroy],
      task_shortcuts_attributes: %i[id live order shortcut_id],
      task_contacts_attributes: %i[contact_type id]
    )
  end

  def donor_params
    params.require(:task).permit(
      donor: %i[task_id mode]
    )
  end

  def create_new
    @disabled_stages = disabled_stages(@insertion_task, position: @insert_mode)
    # initialise with stage of the task
    @task.stage = @insertion_task ? @insertion_task.stage : @timeline.stages.first

    @task.build
  end
end
# rubocop:enable Metrics/ClassLength
