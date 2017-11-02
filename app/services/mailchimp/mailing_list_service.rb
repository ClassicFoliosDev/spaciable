# frozen_string_literal: true

module Mailchimp
  class MailingListService
    require "mailchimp_utils"

    def self.call(resource)
      api_key = resource.parent.api_key if resource&.respond_to?(:parent)
      api_key = resource.api_key if api_key.blank?
      return if api_key.blank?

      call_gibbon(api_key, resource)
    end

    def self.call_gibbon(api_key, resource)
      gibbon = MailchimpUtils.client(api_key)
      mail_chimp_list = gibbon.lists.create(body: build_list_params(resource))

      list_id = mail_chimp_list.body[:id]
      resource.update(list_id: list_id)

      Rails.configuration.mailchimp[:merge_fields].each do |field_params|
        gibbon.lists(list_id).merge_fields.create(body: field_params)
      end
      I18n.t("controller.success.create_update", name: resource.to_s)
    rescue Gibbon::MailChimpError, Gibbon::GibbonError => e
      I18n.t("activerecord.errors.messages.mailchimp_failure",
             name: resource.to_s, type: "mailing list", message: e.message)
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
