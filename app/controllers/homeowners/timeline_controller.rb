# frozen_string_literal: true

module Homeowners
  class TimelineController < Homeowners::BaseController
    before_action :build_timeline

    # show is expected to service any of the timeline
    # views depending on the state.  Splash at the start,
    # select_stage, click on a task in the timeline,
    # display their last viewed last task , or when
    # the timeline is complete
    def show
      return unless current_resident
      return not_allowed unless current_resident&.plot_residency_homeowner?(@plot)

      # If they have specified a start stage
      @task = @timeline.stage_head(params[:stage]) if params[:stage]
      # If the have selected an individual task
      @task = @timeline.task(params[:id]) if params[:id]

      record_progress

      render task || @complete || params[:page] || :splash
    end

    # viewed is called on submit of a task page.  It records the
    # response and moves to the next page.  viewed also gets called
    # via a js postback when No is pressed on a task.  This ensures
    # the action is recorded even if the page isn't submitted
    def viewed
      return unless current_resident
      return not_allowed unless current_resident&.plot_residency_homeowner?(@plot)

      @task = @timeline.task(params[:id])
      @plot_timeline.log(@task, params[:response].to_sym)

      respond_to do |format|
        format.html do
          @task = @task.next
          record_progress(@task.nil?)
          render task || :complete
        end
        format.json { render json: { status: 200 } }
      end
    end

    private

    # The plotTimeline is the root
    def build_timeline
      @plot_timeline = PlotTimeline.find_by(plot_id: @plot.id)
      @timeline = @plot_timeline.timeline # the timeline
      @task = @plot_timeline.timeline_task # the last recorded task
      @logs = @plot_timeline.task_logs # all recorded logs
      @complete = :complete if @plot_timeline.complete
    end

    # record the current task and if the timeline is complete
    def record_progress(complete = false)
      @plot_timeline.update(timeline_task_id: @task&.id,
                            complete: complete)
    end

    def task
      :task if @task
    end
  end
end
