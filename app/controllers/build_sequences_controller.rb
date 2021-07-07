# frozen_string_literal: true

class BuildSequencesController < ApplicationController

  load_and_authorize_resource :developer
  load_and_authorize_resource :division
  load_and_authorize_resource :build_sequence

  def show
  end
end
