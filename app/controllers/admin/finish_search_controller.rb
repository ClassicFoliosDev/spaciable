# frozen_string_literal: true

module Admin
  class FinishSearchController < ApplicationController
    skip_authorization_check
    include SearchConcern

    # rubocop:disable Metrics/AbcSize
    def new
      searchterm = params[:search_term].downcase.tr("\"", "")

      results = finish_full_search(searchterm)
      # create an array of hashes of id and full_name to return
      full = results.map do |finish|
        f = Finish.find(finish.id)
        { id: f.id,
          name: f.full_name,
          path: finish_path(f.id) }
      end

      if params[:search_term] != searchterm
        searchterm = params[:search_term].downcase.tr("\"", "")
        full.select! { |r| r[:name].downcase.include?(searchterm) }
      end

      render json: full
    end
    # rubocop:enable Metrics/AbcSize
  end
end
