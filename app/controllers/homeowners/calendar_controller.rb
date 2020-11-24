# frozen_string_literal: true

module Homeowners
  class CalendarController < Homeowners::BaseController
    skip_authorization_check

    after_action only: %i[index] do
      record_event(:view_calendar,
        category1: I18n.t("ahoy.calendar.calendar_viewed"))
    end

    def index
      @preload = Event.find(params[:event]) if params[:event]
    end
  end
end
