# frozen_string_literal: true

class EventsController < ApplicationController
  skip_authorization_check

  before_action :split_params, except: %i[index destroy]
  load_and_authorize_resource :event, only: %i[destroy]

  def index
    events = []
    Event.within_range(params).each do |event|
      attrs = event.attributes
      attrs[:repeater] = event.repeater?
      attrs[:resources] = event.event_resources.map(&:attributes)
      events << attrs
    end

    render json: events
  end

  def create
    event = Event.build(@event_params, @residents)
    render json: event.attributes
  end

  def update
    event = Event.find(@event_params[:id])
    event.update(@event_params,
                 @residents,
                 params[:repeat_opt] || Event.repeat_edits[:this_event])
    render json: event.attributes
  end

  def destroy
    @event.remove(params[:repeat_opt])
    render json: { status: 200 }
  end

  def permitted_params
    params.require(:event).permit(:id, :master_id,
                                  :eventable_type, :eventable_id,
                                  :title, :location, :start_date,
                                  :start_time, :end_date, :end_time,
                                  :reminder, :repeat, :repeat_until,
                                  residents: [])
          .merge(userable: current_user)
  end

  # The params need to be split into Event and Reseident specifics
  def split_params
    @event_params = event_params
    @residents = @event_params.extract!(:residents)[:residents]
  end

  # Process the event parameters to match the Event record format
  # The times coming back will be local but they need converting to
  # utc for the database
  def event_params
    e_params = permitted_params
    e_params[:start] = permitted_params[:start_time]
    e_params[:end] = permitted_params[:end_time]
    e_params.extract!(:start_date, :start_time, :end_date, :end_time)
    e_params[:master_id] = nil if e_params[:master_id] == "0"
    e_params
  end
end
