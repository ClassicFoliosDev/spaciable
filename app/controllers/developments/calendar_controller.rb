# frozen_string_literal: true

module Developments
  class CalendarController < ApplicationController
    include PaginationConcern
    include SortingConcern

    load_and_authorize_resource :development

    def index
      @preload = Event.find(params[:event]) if params[:event]
    end
  end
end
