# frozen_string_literal: true

require "stripe"

module Api
  module Stripe
    class WebhookController < ActionController::Base
      respond_to :json

      def construct_event
        event = nil
        status = 200

        begin
          event = StripeAction.construct_event(request)
        rescue JSON::ParserError
          status 400
        rescue ::Stripe::SignatureVerificationError
          status 400
        end

        return event, status
      end
    end
  end
end
