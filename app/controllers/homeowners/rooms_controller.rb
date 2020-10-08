# frozen_string_literal: true

module Homeowners
  class RoomsController < Homeowners::BaseController
    skip_authorization_check

    after_action only: %i[show] do
      record_event(:view_rooms)
    end

    def show
      @rooms = @plot.rooms
                    .includes(:finish_rooms,
                              :finishes,
                              :finish_manufacturers,
                              :appliance_rooms,
                              :appliances,
                              :appliance_manufacturers,
                              :appliance_categories)
    end
  end
end
