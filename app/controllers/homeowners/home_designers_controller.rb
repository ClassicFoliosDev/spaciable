# frozen_string_literal: true

module Homeowners
  class HomeDesignersController < Homeowners::BaseController
    after_action only: %i[show] do
      record_event(:view_home_designer)
    end

    def show
      redirect_to dashboard_path if @plot.free? || !@plot.enable_roomsketcher?
    end
  end
end
