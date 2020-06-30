
# frozen_string_literal: true

class EventsController < ApplicationController
  skip_authorization_check

  def index
    events = Event.within_range(params)
    render json: events.map(&:attributes)
  end

  def create
    event = Event.create(create_params)
    render json: event.attributes
  end

  def update
    event = Event.find(update_params[:id])
    event.update_attributes(update_params)
    render json: event.attributes
  end

  def update_params
    params.require(:event).permit(:eventable_type, :eventable_id, :title, :location, :start, :end, :id)
          .merge(userable: current_user)
  end

  def create_params
    params.require(:event).permit(:eventable_type, :eventable_id, :title, :location, :start, :end)
          .merge(userable: current_user)
  end

end
