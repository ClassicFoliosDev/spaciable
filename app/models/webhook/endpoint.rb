# frozen_string_literal: true

module Webhook
  class Endpoint < ApplicationRecord
    attribute :sources, :string, array: true, default: []

    validates :target_url,
              presence: true,
              format: URI.regexp(%w[http https])

    validates :sources, presence: true

    def self.table_name_prefix
      "webhook_"
    end

    def self.for_source(source)
      where("sources @> ARRAY[?]::varchar[]", Array(source))
    end

    def deliver(event)
      Webhook::WeblinkJob.perform_later(id, event.to_json)
    end
  end
end
