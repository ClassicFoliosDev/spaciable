# frozen_string_literal: true
module Homeowners
  class LibraryController < Homeowners::BaseController
    skip_authorization_check

    def show
      @brand = current_resident.brand
      @plot = current_resident.plot
    end
  end
end
