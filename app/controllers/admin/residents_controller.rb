# frozen_string_literal: true

module Admin
  class ResidentsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    load_and_authorize_resource :resident

    def index
      return redirect_to root_path unless current_user.cf_admin?

      @residents = Resident.all
      @residents = sort(@residents, default: :updated_at)
      @residents = paginate(@residents)
    end

    def show; end
  end
end
