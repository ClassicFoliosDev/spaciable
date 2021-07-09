# frozen_string_literal: true

class BuildSequencesController < ApplicationController
  load_and_authorize_resource :developer
  load_and_authorize_resource :division
  load_and_authorize_resource :build_sequence

  before_action :set_parent

  def show; end

  def edit; end

  def set_parent
    @parent = @division || @developer
  end
end
