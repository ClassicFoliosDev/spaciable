# frozen_string_literal: true

module Homeowners
  class CalendarController < Homeowners::BaseController
    skip_authorization_check

    def index
      @preload = Event.find(params[:event]) if params[:event]
    end
  end
end
