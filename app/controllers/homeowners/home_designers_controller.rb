# frozen_string_literal: true

module Homeowners
  class HomeDesignersController < Homeowners::BaseController
    after_action only: %i[show] do
      record_event(:view_home_designer)
    end

    def show; end
  end
end
