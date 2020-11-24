# frozen_string_literal: true

module Homeowners
  class EventsController < Homeowners::BaseController
    skip_authorization_check

    before_action only: %i[feedback viewed] do
      record_event(:view_calendar,
                   category1: I18n.t("ahoy.calendar.#{params[:status]}"))
    end

    def index
      events = []
      parent = params[:eventable_type]
               .classify.constantize
      parent&.resident_events(current_resident, params)&.each do |event|
        # It is possible that a resident has multiple resources
        # for a single event. e.g. if the resident has multiple plots. This
        # needs a seperate event for each plot to be made
        event.event_resources.each do |resource|
          next unless current_resident.related?(resource)

          attrs = event.attributes
          attrs[:editable] = false
          attrs[:homeowner] = resource.attributes
          events << attrs
        end
      end

      render json: events
    end

    def viewed; end

    # Homeowner response to a proposed event
    def feedback
      event = Event.find(params[:event_id])
      resource = event.event_resources.find_by(resourceable_id: params[:resourceable_id],
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
