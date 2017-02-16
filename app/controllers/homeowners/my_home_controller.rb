# frozen_string_literal: true
module Homeowners
  class MyHomeController < Homeowners::BaseController
    skip_authorization_check

    def show
      @plot = current_resident.plot
      @brand = current_resident.brand
    end
  end
end
