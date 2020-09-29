# frozen_string_literal: true

module Homeowners
  class HomeTourController < Homeowners::BaseController
    after_action only: %i[show] do
      record_event(:view_home_tour)
    end

    def show; end
  end
end
