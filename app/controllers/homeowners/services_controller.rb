# frozen_string_literal: true

module Homeowners
  class ServicesController < Homeowners::BaseController
    skip_authorization_check

    def index
      @services = @plot.services if current_resident
    end
  end
end
