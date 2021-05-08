# frozen_string_literal: true

# frozen_string_literal: true

require "net/http"

module Webhook
  class DeliveryWorker
    include Sidekiq::Worker

    def perform(endpoint_id, payload)
      endpoint = Webhook::Endpoint.find(endpoint_id)
      return unless endpoint
      response = request(endpoint.target_url, payload)

      case response.code
      when 410
        endpoint.destroy
      when 400..599
        raise response.to_s
      end
    end

    def request(endpoint, payload)
      uri = URI.parse(endpoint)

      request = Net::HTTP::Post.new(uri.request_uri)
      request["Content-Type"] = "application/json"
      request.body = payload

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")

      http.request(request)
    end
  end
end
