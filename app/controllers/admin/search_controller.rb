# frozen_string_literal: true

module Admin
  class SearchController < ApplicationController
    skip_authorization_check

    def new
      # filter the search results to just those readable
      result_list = PgSearchService.call(self, params[:search_term])
                                   .select { |match| readable?(match) }

      if params[:search_term].include?("\"")
        searchterm = params[:search_term].downcase.tr("\"", "")
        result_list.select! { |r| r[:name].downcase.include?(searchterm) }
      end

      render json: result_list
    end

    private

    # Is the matching search item readable by the current user?
    def readable?(match)
      return true if match[:id] == "-1" # indicates no matches
      # instantiate an object of the matching type using the id
      instance = match[:type].strip.classify.constantize.find_by(id: match[:id])
      # check if the instance is readable
      instance.present? && (can? :read, instance)
    end
  end
end
