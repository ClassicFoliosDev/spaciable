# frozen_string_literal: true

module Admin
  class ResidentsController < ApplicationController
    include PaginationConcern
    include SortingConcern
    skip_authorization_check only: :index
    load_and_authorize_resource :resident

    def index
      if current_user.cf_admin?
        @residents = Resident.joins(:plot_residency)
                             .where(plot_residencies: { resident_id: @residents.pluck(:id) })
      else
        plots = current_user.permission_level.plots
        @residents = plots.map(&:resident)
      end

      @residents = sort(@residents, default: :updated_at)
      @residents = paginate(@residents)
    end

    def show; end
  end
end
