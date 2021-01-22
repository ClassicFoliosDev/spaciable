# frozen_string_literal: true

class StageSetsController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :timeline
  load_and_authorize_resource :stage_set

  before_action :set_stages, only: %i[update]

  def edit; end

  def update
    if differs?

      ActiveRecord::Base.transaction do
        remove_deleted_stages

        if @stage_set.clone?
        else
          create_new_stage_set
        end

        # update timeline stage set
        @timeline.update_attributes(stage_set: @stage_set)
        resolve_stages
        @timeline.refactor

        # raise ActiveRecord::Rollback
      end
    end

    redirect_to timeline_path @timeline
  end

  def stage_set_params
    params.require(:stage_set).permit(
      stages_attributes: %i[id order title]
    )
  end

  private

  def differs?
    @prev != @next
  end

  # remove timeline tasks associated with any removed stages
  def remove_deleted_stages
    @prev.each do |p|
      next unless @next.select { |s| s["id"] == p["id"] }.empty?
      @timeline.remove_stage(Stage.find(p["id"]))
    end
  end

  # create a new stage set from thje new data
  def create_new_stage_set
    @stage_set = StageSet.new(stage_set_type: @stage_set.stage_set_type,
                              clone: true)
    @next.each_with_index do |stage, order|
      @stage_set.stages.build(title: stage[:title],
                              order: order)
    end
    @stage_set.save!
  end

  # Look through the old stages and see where the stage id is in the new
  # stages.  Then replace old stage ids where necessary
  def resolve_stages
    @prev.each do |s|
      # what position is the id now in?
      new_order = @next.each_index.select { |n| @next[n]["id"] == s["id"] }[0]
      next unless new_order
      # reset the stage
      @timeline.change_stage(Stage.find(s["id"]), @stage_set.stages[new_order])
    end
  end

  # Create hashes of the old and the new stages.  These need to be formatted
  # identically so they can be compared. They are used to identfy the changes
  # and the updates needed
  def set_stages
    @stage_set = StageSet.find(params[:id])
    @prev = @stage_set.stages.each.map do |s|
      s.attributes.except("created_at", "updated_at", "stage_set_id")
    end
    @next = stage_set_params[:stages_attributes].to_h
                                                .each.map { |s| s[1] }
                                                .each do |s|
      s[:id] = s[:id].to_i
      s[:order] = s[:order].to_i
    end
  end
end
