# frozen_string_literal: true

module Api
  module Stripe
    module V1
      class EventController < Api::Stripe::WebhookController
        def charge
          event, status = construct_event

          case event.type
          when "checkout.session.completed"
            payload = event.data.object
            Resident.find(payload&.metadata&.resident_id)
              &.payment_received(payload&.payment_link,
                                 payload&.metadata&.payment_for)
          end

          render json: {}, status: status
        end
      end
    end
  end
end
