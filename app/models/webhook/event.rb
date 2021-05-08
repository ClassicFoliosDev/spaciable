# frozen_string_literal: true

module Webhook
  class Event
    attr_reader :event_name, :payload

    def initialize(event_name, payload = {})
      @event_name = event_name
      @payload = payload
    end

    def as_json(*args)
      hash = payload.transform_values do |value|
        serialize_resource(value).as_json(*args)
      end

      hash[:event_name] = event_name
      hash
    end

    private

    def serialize_resource(resource)
      ActiveModelSerializers::SerializableResource.new(resource, {})
    end
  end
end
