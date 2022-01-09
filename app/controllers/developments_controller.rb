# frozen_string_literal: true

class DevelopmentsController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :development, only: %i[index]

  def index
    @developments = paginate(sort(@developments, default: :name))
  end
end
