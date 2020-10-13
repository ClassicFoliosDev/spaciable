# frozen_string_literal: true

module Homeowners
  class AreaGuidesController < Homeowners::BaseController
    after_action only: %i[show] do
      record_event(:view_area_guide)
    end

    def show; end
  end
end
