# frozen_string_literal: true
module Homeowners
  class MyHomeController < Homeowners::BaseController
    skip_authorization_check

    def show
      @rooms = @plot.rooms
                    .includes(:finish_rooms,
                              :finishes,
                              :appliance_rooms,
                              :appliances,
                              :manufacturers,
                              :appliance_categories)
    end
  end
end
