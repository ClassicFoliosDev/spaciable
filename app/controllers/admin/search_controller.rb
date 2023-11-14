# frozen_string_literal: true

module Admin
  class SearchController < ApplicationController
    include SearchConcern
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

    def residents
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

    def admin_users
      searchterm = params[:search_term].downcase

      admins = admin_search(searchterm)
      # create an array of hashes of id and full_name to return
      full = admins.map do |admin|
        { id: admin.id,
          type: "",
          name: "#{admin} #{admin.email}",
          path: admin_user_path(admin) }
      end

      render json: full
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
