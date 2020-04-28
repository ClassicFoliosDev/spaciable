# frozen_string_literal: true

class TimelineTasksController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :timeline
  load_and_authorize_resource :timeline_task, except: %i[create show_timeline]

  before_action do
    @stages = @timeline.stages.select(:title).order(:id).pluck(:id,:title)
  end

  def new
    @insert_mode = params[:insert].to_sym # insert first/before/after
    # task being inserted before/after
    @insertion_task = params[:task] ? TimelineTask.find(params[:task]) :nil
    @disabled_stages = disabled_stages(@insertion_task, position: @insert_mode)
    # initialise with stage of the task
    @timeline_task.stage = @insertion_task ? @insertion_task.stage :
                                             @timeline.stages.first
    @timeline_task.task = Task.new()
  end

  def empty
    # render an empty timeline
    render :show
  end

  def show
    @disabled_stages = @timeline.stages.pluck(:id)
    @checked_stage = @timeline_task&.stage_id
  end

  def edit
    @disabled_stages = disabled_stages(@timeline_task)
    @checked_stage = @timeline_task&.stage_id
  end

  def update
    if @timeline_task.update_from?(timeline_task_params)
      redirect_to timeline_timeline_task_path, notice: t("controller.success.update", name: @timeline_task.title)
    else
      render :edit
    end
  end

  def create
    case timeline_task_params[:donor][:mode].to_sym
    when :before
      after = TimelineTask.find_by(id: timeline_task_params[:donor][:task_id])
      prev = @timeline.before(after)
    when :after
      prev = TimelineTask.find_by(id: timeline_task_params[:donor][:task_id])
      after = @timeline.after(prev)
    end

    @timeline_task = TimelineTask.create_with timeline_task_params, @timeline, prev, after
    redirect_to [@timeline, @timeline_task] , notice: t("controller.success.create", name: @timeline_task.title)
  end

  def destroy
    @timeline_task.remove
    notice = t(".success", title: @timeline_task.title)
    redirect_to [@timeline, (@timeline_task.next || @timeline.tail)] , notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def timeline_params
    params.require(:timeline_task).permit(
      stage: %i[option],
      task: %i[title question answer response positive negative not_applicable],
      feature: %i[title description link],
      action: %i[title description link],
      shortcuts: %i[how_tos faqs services area_guide]
    )
  end

  # When editing or adding a task, only particular stages can be selected
  # based on the previous and next
  def disabled_stages(ttask, position: :at)

    case position
    when :first
      prev = after = nil
    when :at
      prev = @timeline.before(ttask)
      after = @timeline.after(ttask)
    when :before
      prev = @timeline.before(ttask)
      after = ttask
    when :after
      prev = ttask
      after = @timeline.after(ttask)
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

  def timeline_task_params
    params.require(:timeline_task).permit(
      stage: %i[option],
      donor: %i[task_id mode],
      task: %i[title question answer response positive negative not_applicable],
      feature: %i[title description link],
      action: %i[title description link],
      shortcuts: %i[how_tos faqs services area_guide]
      )
  end

end
