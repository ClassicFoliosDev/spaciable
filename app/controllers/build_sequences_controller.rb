# frozen_string_literal: true

class BuildSequencesController < ApplicationController
  load_and_authorize_resource :developer
  load_and_authorize_resource :division
  load_and_authorize_resource :build_sequence

  before_action :set_parent

  def show; end

  def edit; end

  def update
    @build_sequence.update(build_sequence_params)
    redirect_to [@build_sequence]
  end

  def build_sequence_params
    params.require(:build_sequence).permit(
      build_steps_attributes: %i[id order title description _destroy]
    )
  end

  def set_parent
    @parent = @division || @developer
  end
end
