# frozen_string_literal: true

class ProgressesController < ApplicationController
  include SortingConcern

  load_and_authorize_resource :phase, only: %i[index bulk_update]
  load_and_authorize_resource :plot, only: [:show]

  def index
    @plots = sort(@phase.plots, default: :number)
  end
end
