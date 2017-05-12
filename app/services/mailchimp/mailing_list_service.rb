# frozen_string_literal: true
module Mailchimp
  class MailingListService
    require "mailchimp_utils"

    def self.call(resource)
      # Don't create the list again if we already have one: just return the list id
      return resource.list_id if resource.list_id

      # Give up if there is no API key: we don't have any way to contact mailchimp
      api_key = resource.api_key
      return true unless api_key

      list_id = call_gibbon(api_key, list_id, resource)
      resource.update(list_id: list_id)

      list_id
    end

    def self.call_gibbon(api_key, list_id, resource)
      list_params = build_list_params(resource)
      begin
        gibbon = MailchimpUtils.client(api_key)
        mail_chimp_list = gibbon.lists.create(body: list_params)
        list_id = mail_chimp_list.body[:id]

        Rails.configuration.mailchimp[:merge_fields].each do |field_params|
          gibbon.lists(list_id).merge_fields.create(body: field_params)
        end
      rescue Gibbon::MailChimpError => e
        return e.message
      end

      list_id
    end

    def self.build_list_params(resource)
      {
        name: resource.to_s,
        contact: build_contact,
        permission_reminder: I18n.t("mailchimp.reminder"),
        campaign_defaults: {
          from_name: I18n.t("mailchimp.from_name"),
          from_email: I18n.t("mailchimp.from_email"),
          subject: "",
          language: I18n.t("mailchimp.language")
        },
        # Allow users to select html or plain text for email contents
        email_type_option: true
      }
    end

    def self.build_contact
      {
        company: I18n.t("mailchimp.company"),
        address1: I18n.t("mailchimp.address1"),
        address2: I18n.t("mailchimp.address2"),
        city: I18n.t("mailchimp.city"),
        state: I18n.t("mailchimp.state"),
        zip: I18n.t("mailchimp.zip"),
        country: I18n.t("mailchimp.country")
      }
    end
  end
end
