# frozen_string_literal: true

module Admin
  module Snags
    class PhasesController < ApplicationController
      skip_authorization_check

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
        @phases = Phase.accessible_by(current_ability)
        @phases = paginate(sort(@phases))
      end

      def show
        @plots = @phase.plots
        @plots = paginate(sort(@plots))
      end
    end
  end
end
