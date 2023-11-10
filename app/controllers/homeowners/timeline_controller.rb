# frozen_string_literal: true

module Homeowners
  class TimelineController < Homeowners::BaseController
    before_action :build_timeline

    after_action only: %i[show] do
      if @task
        record_event(@timeline.event_tag,
                     category1: @task&.title,
                     category2: I18n.t("ahoy.#{Ahoy::Event::TASK_VIEWED}"))
        @plot_timeline.log(@task, :negative) if @timeline.stage_set.proforma?
      else
        record_event(@timeline.event_tag,
                     category1: @task&.title || complete || page_name || "Welcome Page")
      end
    end

    # show is expected to service any of the timeline
    # views depending on the state.  Splash at the start,
    # select_stage, click on a task in the timeline,
    # display their last viewed last task , or when
    # the timeline is complete
    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def show
      return unless current_resident
      return unless current_resident&.plot_residency_role?(@plot, %i[homeowner prospect])

      # If they have specified a start stage
      @task = @timeline.stage_head(params[:stage]) if params[:stage]
      # If the have selected an individual task
      @task = @timeline.task(params[:task_id]) if params[:task_id]

      # If this is a proforma and no task has been specified then
      # go straight to the first task
      @task = @timeline.head if @task.nil? && @timeline.stage_set.proforma?

      record_progress

      render task || @complete || params[:page] || :splash
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    # viewed is called on submit of a Task page.  It records the
    # response and moves to the next page.  viewed also gets called
    # via a js postback when No is pressed on a task.  This ensures
    # the action is recorded even if the page isn't submitted
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def viewed
      return unless current_resident
      return unless current_resident&.plot_residency_homeowner?(@plot)

      @task = @timeline.task(params[:task_id])
      @plot_timeline.log(@task, params[:response].to_sym)

      if @task && @timeline.stage_set.journey?
        record_event(
          @timeline.event_tag,
          category1: @task&.title,
          category2: I18n.t("homeowners.timeline.task.#{params[:response_action]}")
        )
      end

      respond_to do |format|
        format.html do
          @task = params[:response_direction] == "forward" ? @task.next : @task.prev
          record_progress(@task.nil?)

          if @task
            record_event(@timeline.event_tag,
                         category1: @task&.title,
                         category2: I18n.t("ahoy.#{Ahoy::Event::TASK_VIEWED}"))
          else
            record_event(@timeline.event_tag,
                         category1: complete)
          end

          render task || :complete
        end
        format.json { render json: { status: :ok } }
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    def collapsed
      pts = PlotTimelineStage.find_or_create_by(plot_timeline_id: @plot_timeline.id,
                                                timeline_stage_id: params[:stage])
      pts.collapsed = params[:collapsed]
      pts.save
      render json: { status: :ok }
    end

    private

    # PlotTimeline is the homeowner reference into a timeline
    def build_timeline
      @timeline = Timeline.find(params[:timeline_id])
      @plot_timeline = PlotTimeline.matching(@plot, @timeline).first
      @task = @plot_timeline&.task # the last recorded Timeline task
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

      "Complete"
    end
  end
end
