# frozen_string_literal: true

module Phases
  class PhaseTimelinesController < ApplicationController
    include PaginationConcern
    include SortingConcern

    load_and_authorize_resource :phase
    load_and_authorize_resource :phase_timeline, except: %i[index]

    before_action :find_available, except: %i[index]

    def index
      @phase_timelines = PhaseTimeline.where(phase: @phase)
    end

    def new
      @phase_timeline = PhaseTimeline.new(phase_id: @phase.id)
      @timelines = Timeline.not_used_in_phase(@phase)
      @plots = Plot.timeline_free(@phase)
    end

    def edit; end

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

    def find_available
      @timelines = Timeline.not_used_in_phase(@phase)
      @plots = Plot.timeline_free(@phase)
      return unless @phase_timeline

      @timelines += [@phase_timeline.timeline]
      @plots += @phase_timeline.plots
    end

    def phase_timeline_params
      params.require(:phase_timeline).permit(
        :timeline_id, :phase_id, plot_ids: []
      )
    end
  end
end
