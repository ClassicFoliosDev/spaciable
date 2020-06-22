# frozen_string_literal: true

module Homeowners
  class MyHomeController < Homeowners::BaseController
    skip_authorization_check

    def show
      if @plot.unit_type.external_link?
        redirect_to homeowner_about_path
      elsif @plot.rooms.any?
        redirect_to homeowner_rooms_path
      else
        redirect_to homeowner_library_path
      end
    end
  end
end
