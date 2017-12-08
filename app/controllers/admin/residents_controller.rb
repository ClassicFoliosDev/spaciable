# frozen_string_literal: true

module Admin
  class ResidentsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    skip_authorization_check only: :index
    load_and_authorize_resource :resident

    def index
      @residents = if current_user.cf_admin?
                     Resident.all
                   else
                     Resident.accessible_by(current_ability)
                   end

      @residents = sort(@residents, default: :updated_at)
      @residents = paginate(@residents)
    end

    def show; end
  end
end
