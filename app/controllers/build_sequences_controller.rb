# frozen_string_literal: true

class BuildSequencesController < ApplicationController
  load_and_authorize_resource :developer
  load_and_authorize_resource :division
  load_and_authorize_resource :global

  before_action :set_parent

  def show; end

  def edit
    @steps_enabled = params[:build_steps]
  end

  def update
    update_steps
    redirect_to [@build_sequence.parent, :build_sequence]
  end

  def build_sequence_params
    params.require(:build_sequence).permit(
      build_steps_attributes: %i[id order title description _destroy]
    )
  end

  # rubocop:disable LineLength
  def update_steps
    BuildSequence.transaction do
      begin
        # If the parent doesn't have a build_sequence, then this 'update'
        # must create one for it.
        @build_sequence = BuildSequence.new(build_sequenceable: @parent) unless @parent.build_sequence

        # update the steps
        @build_sequence.update(build_sequence_params)
        # go through and update the ids to reflect the changes
        @build_sequence.build_steps.each_with_index do |step, v|
          # get the old ids pointing to this step
          old_ids = params[:build_sequence][:build_steps_attributes][v.to_s][:current_ids]
                    .split(",").map(&:to_i)
          # now update all plots pointing at old_ids to the new id of this step
          @build_sequence.update_build_steps(old_ids, step.id)
        end
      rescue => e
        Rails.logger.debug(e.message)
        ActiveRecord::Rollback
      end
    end
  end
  # rubocop:enable LineLength

  def set_parent
    @parent = @division || @developer || @global
    @build_sequence = @parent.sequence_in_use
  end
end
