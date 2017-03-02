# frozen_string_literal: true
module Homeowners
  class MyHomeController < Homeowners::BaseController
    skip_authorization_check

    def show
      @rooms = @plot.rooms
    end
  end
end
