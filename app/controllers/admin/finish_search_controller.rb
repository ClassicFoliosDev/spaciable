# frozen_string_literal: true

module Admin
  class FinishSearchController < ApplicationController
    skip_authorization_check
    include SearchConcern

    def new
      results = ilike_search(Finish, params[:search_term])
      render json: results
    end
  end
end
