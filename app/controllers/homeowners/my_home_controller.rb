# frozen_string_literal: true
module Homeowners
  class MyHomeController < Homeowners::BaseController
    skip_authorization_check

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
