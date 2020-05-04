# frozen_string_literal: true

class TimelinesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_resource :global
  load_and_authorize_resource :developer
  load_and_authorize_resource :timeline,
                              through: %i[developer global],
                              shallow: true, except: [:clone]
  load_and_authorize_resource :timeline, only: [:clone]

  before_action :set_parent

  def index
    @timelines = paginate(sort(@parent.timelines, default: :title))
  end

  def new; end

  def edit; end

  def show
    authorize! :show, @timeline

    if @timeline.head
      # view the head task
      redirect_to timeline_task_path @timeline, @timeline.head
    else
      # no tasks to view
      redirect_to timeline_empty_path @timeline
    end
  end

  def create
    if @timeline.save
      redirect_to [@parent, :timelines],
                  notice: t("controller.success.create", name: @timeline.title)
    else
      render :new
    end
  end

  def update
    if @timeline.update(timeline_params)
      redirect_to [@parent, :timelines],
                  notice: t("controller.success.update", name: @timeline.title)
    else
      render :edit
    end
  end

  def destroy
    @timeline.destroy!
    notice = t("controller.success.destroy", name: @timeline.title)
    redirect_to [@parent, :timelines], notice: notice
  rescue ActiveRecord::InvalidForeignKey => e
    notice = t("activerecord.errors.messages.delete_not_possible",
               name: @timeline.title,
               types: "records")
    redirect_to [@parent, :timelines], alert: notice
  end

  def clone
    alert = notice = nil
    @timeline.clone do |new_timeline, error|
      if error.present?
        alert = t("activerecord.errors.messages.timeline_bad_clone",
                  name: Timeline.find(params[:tid])&.title,
                  error: error)
      else
        notice = t("controller.success.create", name: new_timeline.title)
      end
    end

    redirect_to [@parent, :timelines], alert: alert, notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def timeline_params
    params.require(:timeline).permit(
      :title
    )
  end

  def set_parent
    @parent = @developer || @global || @timeline&.timelineable
    @timeline&.timelineable = @parent
  end
end
