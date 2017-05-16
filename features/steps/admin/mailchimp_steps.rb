# frozen_string_literal: true
Given(/^I have configured an API key$/) do
  module Mailchimp
    class MailingListService
      def self.call(resource)
        I18n.t("controller.success.create_update", name: resource.to_s)
      end
    end

    class SegmentService
      def self.call(development)
        I18n.t("controller.success.create_update", name: development.name)
      end
    end

    class MarketingMailService
      def self.call(_resident, _plot_residency = nil, _hooz_status = nil)
        nil
      end
    end
  end
end
