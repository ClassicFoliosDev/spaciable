# frozen_string_literal: true

module Webhook
  class Endpoint < ApplicationRecord
    attribute :events, :string, array: true, default: []

    validates :target_url,
              presence: true,
              format: URI.regexp(%w[http https])

    def self.table_name_prefix
      "webhook_"
    end

    def deliver(event)
      Webhook::DeliveryWorker.perform_async(id, event.to_json)
    end
  end
end
