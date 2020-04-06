# frozen_string_literal: true

module Admin
  class FinishSearchController < ApplicationController
    skip_authorization_check
    include SearchConcern

    def new
      results = finish_full_search(params[:search_term])
      # create an array of hashes of id and full_name to return
      full = results.map do |finish|
        f = Finish.find(finish.id)
        { id: f.id, name: f.full_name }
      end

      render json: full
    end
  end
end
