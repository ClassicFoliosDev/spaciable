# frozen_string_literal: true

module Homeowners
  class MaintenanceController < Homeowners::BaseController
    after_action only: %i[show] do
      record_event(:view_issues)
    end

    def show; end
  end
end
