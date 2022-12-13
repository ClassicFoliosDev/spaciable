# frozen_string_literal: true

class StripeAction
  ::Stripe.api_key = ENV["STRIPE_API_KEY"]
  ENDPOINT_SECRET = ENV["STRIPE_ENDPOINT_SECRET"]

  class << self
    # Get and authenticate a stripe event
    def construct_event(request)
      payload = request.body.read

      ::Stripe::Event.construct_from(
        JSON.parse(payload, symbolize_names: true)
      )

      # Retrieve the event by verifying the signature using
      # the payload and secret.
      Stripe::Webhook.construct_event(
        payload, request.env["HTTP_STRIPE_SIGNATURE"], ENDPOINT_SECRET
      )
    end

    def create_payment_link(resident, payment_for)
      return Stripe::PaymentLink.create(
        line_items: [
          { price: "price_1MC4nFEWF1UWJpF5QxFlqoYF",
            quantity: 1 }
        ],
        metadata: { resident_id: resident.id,
                    payment_for: payment_for }
      ).url
    rescue => e
      raise "Failed to create payment link for user #{user.id}:" + e.message
    end
    # rubocop:enable Metrics/MethodLength

    def deactivate_payment_link(link)
      success = true

      begin
        Stripe::PaymentLink.update(link, active: false)
      rescue => e
        Rails.logger.debug("Failed to deactivate payment link for user #{link}:" + e.message)
        success = false
      end

      success
    end
  end
end
