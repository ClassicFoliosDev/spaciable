# frozen_string_literal: true
module Admin
  class ApplianceSearchController < ApplicationController
    skip_authorization_check
    include SearchConcern

    def new
      results = appliance_search(params[:search_term])
      render json: results
    end
  end
end
