# frozen_string_literal: true

module Homeowners
  class EventsController < Homeowners::BaseController
    skip_authorization_check

    def index
      events = []
      Event.for_resource_within_range(current_resident, params).each do |event|
        attrs = event.attributes
        attrs[:editable] = false
        attrs[:homeowner] =
          event.event_resources
               .find_by(resourceable: current_resident)&.attributes
        events << attrs
      end

      render json: events
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

    # Homeowner response to a proposed event
    def feedback
      event = Event.find(params[:event_id])
      resource = EventResource.find_by(event_id: params[:event_id],
                                       resourceable_id: params[:resourceable_id],
                                       resourceable_type: params[:resourceable_type])
      if resource
        # update resource before event - post save
        # events depend on order
        resource.update_attributes(resource_params)
        event.update_attributes(repropose_params)
        EventNotificationService.feedback(resource.reload)
      end

      render json: { status: 200 }
    end

    def event_params
      params.require(:event).permit(:eventable_type, :eventable_id,
                                    :title, :location, :start,
                                    :end, :id)
            .merge(userable: current_resident)
    end

    def resource_params
      params.permit(:id, :resourceable_id, :resourceable_type, :status)
    end

    def repropose_params
      params.permit(:proposed_start, :proposed_end)
    end
  end
end
