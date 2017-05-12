# frozen_string_literal: true
module Mailchimp
  class SegmentService
    def self.call(development)
      return true unless development.parent.api_key

      # Create a new mailing list if one doesn't already exist, otherwise the MailingListService
      # will just look up the existing mailing list id
      list_id = Mailchimp::MailingListService.call(development.parent)
      call_gibbon(list_id, development)
    end

    def self.call_gibbon(list_id, development)
      segment_params = build_segment_params(development)

      gibbon = MailchimpUtils.client(development.parent.api_key)
      mail_chimp_segment = gibbon.lists(list_id).segments.create(body: segment_params)
      development.update(segment_id: mail_chimp_segment.body[:id])
      I18n.t("controller.success.create", name: development.name)
    rescue Gibbon::MailChimpError => e
      I18n.t("activerecord.errors.messages.mailchimp_failure",
             name: development.name,
             type: "segment",
             message: e.message)
    end

    def self.build_segment_params(development)
      {
        name: development.to_s,
        options: build_options(development)
      }
    end

    def self.build_options(development)
      {
        match: "any",
        conditions: [
          {
            condition_type: "TextMerge",
            field: "DEVT",
            op: "is",
            value: development.to_s
          }
        ]
      }
    end
  end
end
