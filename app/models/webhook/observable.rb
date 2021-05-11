# frozen_string_literal: true

module Webhook
  module Observable
    extend ActiveSupport::Concern
    include Webhook::Delivery

    included do
      after_create do
        deliver_webhook(:created)
      end

      after_update do
        deliver_webhook(:updated)
      end

      after_destroy do
        deliver_webhook(:destroyed)
      end
    end
  end
end
