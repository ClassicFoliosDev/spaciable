# frozen_string_literal: true

module Admin
  class ApplianceSearchController < ApplicationController
    skip_authorization_check
    include SearchConcern

    def new
      results = appliance_search(params[:search_term])

      full = results.map do |appliance|
        a = Appliance.find(appliance.id)
        { id: a.id,
          name: a.full_name,
          path: appliance_path(a.id) }
      end

      render json: full
    end
  end
end
