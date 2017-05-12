# frozen_string_literal: true
module Mailchimp
  class MarketingMailService
    def self.call(email, plot_residency, hooz_status, subscribed_status)
      return true unless plot_residency.plot.developer.api_key

      # Create a new mailing list if one doesn't already exist, otherwise the MailingListService
      # will just look up the existing mailing list id
      list_id = Mailchimp::MailingListService.call(plot_residency.plot.development.parent)
      merge_fields = build_merge_fields(hooz_status, plot_residency)

      call_gibbon(email, list_id, plot_residency, merge_fields, subscribed_status)
    end

    def self.call_gibbon(email, list_id, plot_residency, merge_fields, subscribed_status)
      begin
        gibbon = MailchimpUtils.client(plot_residency.plot.developer.api_key)
        gibbon.lists(list_id).members(md5_hashed_email(email)).upsert(
          body: { email_address: plot_residency.email,
                  status: subscribed_status, merge_fields: merge_fields }
        )
        notice = I18n.t("controller.success.create", name: plot_residency.plot)
      rescue Gibbon::MailChimpError => e
        notice = t("activerecord.errors.messages.mailchimp_failure",
                   name: email,
                   type: "list subscriber", message: e.message)
      end
      notice
    end

    def self.build_merge_fields(hooz_status, plot_residency)
      return { HOOZSTATUS: hooz_status } unless plot_residency

      { HOOZSTATUS: hooz_status,
        FNAME: plot_residency.first_name,
        LNAME: plot_residency.last_name,
        CDATE: plot_residency.completion_date.to_s,
        DEVT: plot_residency.plot.parent.to_s }
    end

    def self.md5_hashed_email(email)
      Digest::MD5.hexdigest(email.downcase)
    end
  end
end
