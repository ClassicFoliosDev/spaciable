# frozen_string_literal: true

module Admin
  class ResidentsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :resident

    def index
      return redirect_to root_path unless current_user.cf_admin?

      @usearch = UserSearch.new(search_params)
      @residents = UserSearch.residents(@usearch)
      @residents = sort(@residents, default: :updated_at)
      @residents = paginate(@residents)
    end

    def show; end

    def search_params
      return unless params.include?("user_search")

      params.require("user_search").permit(:developer_id, :division_id, :development_id, :role)
    end
  end
end
