# frozen_string_literal: true

module Phases
  class PhaseTimelinesController < ApplicationController
    include PaginationConcern
    include SortingConcern

    load_and_authorize_resource :phase
    load_and_authorize_resource :phase_timeline, except: %i[index new]

    before_action :find_available, only: %i[new edit]

    def index
      @phase_timelines = PhaseTimeline.where(phase: @phase)
    end

    def new
      @scope = params[:scope]
      @phase_timeline = PhaseTimeline.new(phase_id: @phase.id)
    end

    def edit
      @scope = @phase_timeline.stage_set_type
    end

    def update
      if @phase_timeline.update(phase_timeline_params)
        notice = t("controller.success.update", name: @phase_timeline.timeline_title)
        redirect_to phase_phase_timelines_url, notice: notice
      else
        render :edit
      end
    end

    def create
      if @phase_timeline.save
        notice = t("controller.success.create", name: @phase_timeline.timeline_title)
        redirect_to phase_phase_timelines_url, notice: notice
      else
        render :new
      end
    end

    def destroy
      @phase_timeline.destroy
      notice = t("controller.success.destroy", name: @phase_timeline.timeline_title)
      redirect_to phase_phase_timelines_url, notice: notice
    end

    # find available timelines and plots
    def find_available
      type = action_name == "new" ? params[:scope] : @phase_timeline.stage_set.stage_set_type

      @timelines = Timeline.not_used_in_phase(@phase, type)
      @plots = type == "journey" ? Plot.journey_free(@phase) : @phase.plots.order(:id)
      return unless @phase_timeline

      @timelines += [@phase_timeline.timeline]
      @plots += @phase_timeline.plots if type == "journey"
    end

    def phase_timeline_params
      params.require(:phase_timeline).permit(
        :timeline_id, :phase_id, plot_ids: []
      )
    end
  end
end
