# frozen_string_literal: true

module Homeowners
  class EventsController < Homeowners::BaseController
    skip_authorization_check

    def index
      events = Event.for_resource_within_range(current_resident, params)
      render json: events.map(&:attributes)
    end

    def create
      event = Event.build(event_params)
      render json: event.attributes
    end

    def update
      event = Event.find(event_params[:id])
      event.update(event_params)
      render json: event.attributes
    end

    def event_params
      params.require(:event).permit(:eventable_type, :eventable_id,
                                    :title, :location, :start,
                                    :end, :id)
            .merge(userable: current_resident)
    end
  end
end
