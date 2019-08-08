# frozen_string_literal: true

module Homeowners
  class LettingsController < Homeowners::BaseController
    skip_authorization_check

    def show
      return unless current_resident
      @plots = current_resident.plots
      @plots = @plots.order(number: :asc)
    end
  end
end
