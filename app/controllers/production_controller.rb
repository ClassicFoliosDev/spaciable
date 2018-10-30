# frozen_string_literal: true

class ProductionController < ApplicationController
  include PaginationConcern
  include SortingConcern
  load_and_authorize_resource :phase

  def index
    return redirect_to root_path unless current_user.cf_admin?

    @collection = paginate(sort(@phase.plots, default: :number))
  end
end
