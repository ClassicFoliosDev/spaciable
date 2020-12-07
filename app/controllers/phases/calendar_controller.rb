# frozen_string_literal: true

module Phases
  class CalendarController < ApplicationController
    include PaginationConcern
    include SortingConcern

    load_and_authorize_resource :phase

    def index
      @preload = Event.find(params[:event]) if params[:event]
      @active_tab = "calendar"
    end
  end
end
