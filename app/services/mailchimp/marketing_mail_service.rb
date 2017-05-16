# frozen_string_literal: true
module Mailchimp
  class MarketingMailService
    def self.call(resident, plot_residency, hooz_status, subscribed_status)
      plot = plot_residency&.plot || resident&.plot
      return unless plot.api_key

      # Create a new mailing list if one doesn't already exist, otherwise the MailingListService
      # will just look up the existing mailing list id
      parent = plot.development.parent
      Mailchimp::MailingListService.call(parent) unless parent.list_id
      list_id = plot.development.parent.list_id

      subscribed_status = existing_status(plot.api_key,
                                          resident.email,
                                          list_id) if subscribed_status.nil?
      merge_fields = build_merge_fields(hooz_status, resident, plot_residency)

      call_gibbon(resident.email, list_id, merge_fields,
                  subscribed_status, plot.api_key)
    end

    def self.existing_status(api_key, email, list_id)
      gibbon = MailchimpUtils.client(api_key)

      member = gibbon.lists(list_id).members(md5_hashed_email(email)).retrieve
      member.body[:status]
    end

    def self.call_gibbon(email, list_id, merge_fields, subscribed_status, api_key)
      gibbon = MailchimpUtils.client(api_key)

      gibbon.lists(list_id).members(md5_hashed_email(email)).upsert(
        body: { email_address: email,
                status: subscribed_status, merge_fields: merge_fields }
      )
      nil
    rescue Gibbon::MailChimpError => e
      I18n.t("activerecord.errors.messages.mailchimp_failure",
             name: email,
             type: "list subscriber",
             message: e.message)
    end

    def self.build_merge_fields(hooz_status, resident, plot_residency)
      return { HOOZSTATUS: hooz_status } unless resident

      merge_fields = build_resident_fields(hooz_status, resident)

      if plot_residency
        merge_fields[:CDATE] = plot_residency.completion_date.to_s

        residency_fields = build_residency_fields(plot_residency.plot)
        merge_fields = merge_fields.merge(residency_fields)
      end

      merge_fields
    end

    def self.build_resident_fields(hooz_status, resident)
      subscribed = Rails.configuration.mailchimp[:subscribed]
      unsubscribed = Rails.configuration.mailchimp[:unsubscribed]

      {
        HOOZSTATUS: hooz_status,
        FNAME: resident.first_name,
        LNAME: resident.last_name,
        TITLE: resident.title,
        HOOZ_UPD: resident.hoozzi_email_updates&.positive? ? subscribed : unsubscribed,
        PHONE_UPD: resident.telephone_updates&.positive? ? subscribed : unsubscribed,
        POST_UPD: resident.post_updates&.positive? ? subscribed : unsubscribed
      }.transform_values(&:to_s)
    end

    def self.build_residency_fields(plot)
      {
        DEVT: plot.parent,
        POSTAL: plot.postal_name,
        BLDG: plot.building_name,
        ROAD: plot.road_name,
        CITY: plot.city,
        COUNTY: plot.county,
        ZIP: plot.postcode,
        PHASE: plot.phase,
        UNIT_TYPE: plot.unit_type
      }.transform_values(&:to_s)
    end

    def self.md5_hashed_email(email)
      Digest::MD5.hexdigest(email.downcase)
    end
  end
end
