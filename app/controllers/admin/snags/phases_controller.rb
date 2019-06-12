# frozen_string_literal: true

module Admin
  module Snags
    class PhasesController < ApplicationController
      skip_authorization_check
      before_action :snag_permission

      include PaginationConcern
      include SortingConcern

      load_and_authorize_resource :developer
      load_and_authorize_resource :division
      load_and_authorize_resource :development
      load_and_authorize_resource :phase
      load_and_authorize_resource :unit_type
      load_and_authorize_resource :plot
      load_resource :snag, through:
        %i[developer division development phase unit_type plot], shallow: true

      def index
        @phases = Phase.snagging(current_ability)
        @phases = paginate(sort(@phases, default: { unresolved_snags: :desc }))
      end

      def show
        @plots = @phase.plots
        @plots = paginate(sort(@plots))
      end

      private

      def snag_permission
        redirect_to(admin_dashboard_path) && return if current_user.site_admin?
      end
    end
  end
end
