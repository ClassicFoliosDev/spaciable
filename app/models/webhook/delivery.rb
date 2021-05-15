# frozen_string_literal: true

module Webhook
  module Delivery
    extend ActiveSupport::Concern

    def deliver_webhook_event(source, action, payload)
      event = Webhook::Event.new(source, action, payload || {})

      Webhook::Endpoint.for_source(source).each do |endpoint|
        endpoint.deliver(event)
      end
    end

    def webhook_payload
      attributes
    end

    def deliver_webhook(action)
      deliver_webhook_event(self.class.name, action, webhook_payload)
    end
  end
end
