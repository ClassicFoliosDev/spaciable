# frozen_string_literal: true

class TimelinesController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :timeline

  def index
    @timelines = paginate(sort(@timelines, default: :title))
  end

  def new; end

  def edit; end

  def show;
    if @timeline.head
      # view the head task
      redirect_to timeline_timeline_task_path @timeline, @timeline.head
    else
      # no tasks to view
      redirect_to timeline_empty_path @timeline
    end
  end

  def create
    if @timeline.save
      redirect_to timelines_path, notice: t("controller.success.create", name: @timeline.title)
    else
      render :new
    end
  end

  def update
    if @timeline.update(timeline_params)
      redirect_to timelines_path, notice: t("controller.success.update", name: @timeline.title)
    else
      render :edit
    end
  end

  def destroy
    @timeline.destroy!
    notice = t(
      "controller.success.destroy",
      name: @timeline.title
    )
    redirect_to timelines_url, notice: notice
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def timeline_params
    params.require(:timeline).permit(
      :title
    )
  end

end
