# frozen_string_literal: true

module Webhook
  class Event
    attr_reader :event_name, :payload

    def initialize(event_name, payload = {})
      @event_name = event_name
      @payload = payload
    end

    # rubocop:disable Lint/UnusedMethodArgument
    def as_json(*args)
      hash = @payload.dup || {}
      hash[:event_name] = @event_name
      hash
    end
    # rubocop:enable Lint/UnusedMethodArgument
  end
end
