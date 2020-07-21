# frozen_string_literal: true

module Admin
  class ResidentSearchController < ApplicationController
    skip_authorization_check
    include SearchConcern

    def new
      searchterm = params[:search_term].downcase

      residents = resident_search(searchterm)
      # create an array of hashes of id and full_name to return
      full = residents.map do |resident|
        { id: resident.id,
          type: "",
          name: "#{resident} #{resident.email}",
          path: admin_resident_path(resident) }
      end

      render json: full
    end
  end
end
