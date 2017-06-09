# frozen_string_literal: true
module Admin
  class SearchController < ApplicationController
    skip_authorization_check

    def new
      result_list = PgSearchService.call(self, params[:search_term])
      render json: result_list
    end
  end
end
