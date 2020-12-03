# frozen_string_literal: true

module Homeowners
  class TimelineController < Homeowners::BaseController
    before_action :build_timeline

    after_action only: %i[show] do
      if @task
        record_event(:view_your_journey,
                     category1: @task&.title,
                     category2: I18n.t("ahoy.#{Ahoy::Event::TASK_VIEWED}"))
      else
        record_event(:view_your_journey,
                     category1: @task&.title || complete || page_name || "Welcome Page")
      end
    end

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

    # viewed is called on submit of a Task page.  It records the
    # response and moves to the next page.  viewed also gets called
    # via a js postback when No is pressed on a task.  This ensures
    # the action is recorded even if the page isn't submitted
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def viewed
      return unless current_resident
      return not_allowed unless current_resident&.plot_residency_homeowner?(@plot)

      @task = @viewed_task = @timeline.task(params[:id])
      @plot_timeline.log(@task, params[:response].to_sym)

      if @task
        record_event(
          :view_your_journey,
          category1: @task&.title,
          category2: I18n.t("homeowners.timeline.task.#{params[:response_action]}")
        )
      end

      respond_to do |format|
        format.html do
          @task = @task.next
          record_progress(@task.nil?)

          if @task
            record_event(:view_your_journey,
                         category1: @task&.title,
                         category2: I18n.t("ahoy.#{Ahoy::Event::TASK_VIEWED}"))
          else
            record_event(:view_your_journey,
                         category1: complete)
          end

          render task || :complete
        end
        format.json { render json: { status: 200 } }
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    private

    # PlotTimeline is the homeowner reference into a timeline
    def build_timeline
      @plot_timeline = PlotTimeline.find_by(plot_id: @plot.id)
      @timeline = @plot_timeline.timeline # the timeline
      @task = @plot_timeline.task # the last recorded Timeline task
      @logs = @plot_timeline.task_logs # all recorded logs
      @complete = :complete if @plot_timeline.complete
    end

    # record the current task and if the timeline is complete
    def record_progress(complete = false)
      @complete = complete
      @plot_timeline.update(task_id: @task&.id,
                            complete: complete)
    end

    def task
      :task if @task
    end

    def page_name
      return unless params[:page]

      params[:page].split("_").map(&:capitalize).join(" ")
    end

    def complete
      return unless @complete

      I18n.t("homeowners.timeline.done")
    end
  end
end
