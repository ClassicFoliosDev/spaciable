# frozen_string_literal: true

module Homeowners
  class MyHomeController < Homeowners::BaseController
    skip_authorization_check

    after_action only: %i[show] do
      record_event(:view_my_home)
    end

    def show
      if @plot.unit_type.external_link?
        redirect_to homeowner_home_tour_path
      elsif @plot.rooms.any?
        redirect_to homeowner_rooms_path
      else
        redirect_to homeowner_library_path
      end
    end
  end
end
