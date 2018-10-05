# frozen_string_literal: true

module Mailchimp
  class MarketingMailService
    def self.call(resident,
                  plot,
                  hooz_status = Rails.configuration.mailchimp[:activated])
      api_key = plot&.api_key
      return if api_key.blank?

      # Create a new mailing list if one doesn't already exist, otherwise the MailingListService
      # will just look up the existing mailing list id
      parent = plot.development.parent
      Mailchimp::MailingListService.call(parent) unless parent.list_id
      list_id = plot.development.parent.list_id

      merge_fields = build_merge_fields(hooz_status, resident, plot)
      call_gibbon(resident, list_id, merge_fields, plot.api_key)
    end

    def self.update_services(resident, plot, service_ids)
      api_key = plot&.api_key
      return if api_key.blank?
      list_id = plot.development.parent.list_id
      return if list_id.blank?

      services_fields = build_services_fields(service_ids)
      call_gibbon(resident, list_id, services_fields, plot.api_key)
    end

    def self.call_gibbon(resident, list_id, merge_fields, api_key)
      @gibbon = MailchimpUtils.client(api_key)

      update_member(list_id, resident, merge_fields)

      nil
    rescue Gibbon::MailChimpError, Gibbon::GibbonError => e
      I18n.t("activerecord.errors.messages.mailchimp_failure", name: resident.email,
                                                               type: "list subscriber",
                                                               message: e.message)
    end

    def self.update_member(list_id, resident, merge_fields)
      @gibbon.lists(list_id).members(md5_hashed_email(resident.email)).upsert(
        body: { email_address: resident.email, status: resident.subscribed_status,
                merge_fields: merge_fields }
      )
    end

    def self.build_merge_fields(hooz_status, resident, plot)
      return { HOOZSTATUS: hooz_status } unless resident

      merge_fields = build_resident_fields(hooz_status, resident)

      if plot
        merge_fields[:CDATE] = plot.completion_date.to_s

        residency_fields = build_residency_fields(plot)
        merge_fields = merge_fields.merge(residency_fields)
      end

      merge_fields
    end

    def self.build_resident_fields(hooz_status, resident)
      subscribed = Rails.configuration.mailchimp[:subscribed]
      unsubscribed = Rails.configuration.mailchimp[:unsubscribed]

      {
        HOOZSTATUS: hooz_status, FNAME: resident.first_name,
        LNAME: resident.last_name, TITLE: resident.title,
        DEVLPR_UPD: resident.developer_email_updates&.positive? ? subscribed : unsubscribed,
        HOOZ_UPD: resident.hoozzi_email_updates&.positive? ? subscribed : unsubscribed,
        PHONE_UPD: resident.telephone_updates&.positive? ? subscribed : unsubscribed,
        POST_UPD: resident.post_updates&.positive? ? subscribed : unsubscribed,
        PHONE: resident.phone_number
      }.transform_values(&:to_s)
    end

    def self.build_residency_fields(plot)
      {
        DEVT: plot.development, POSTAL: plot.postal_number,
        BLDG: plot.building_name, ROAD: plot.road_name,
        LOCL: plot.locality, CITY: plot.city,
        COUNTY: plot.county, ZIP: plot.postcode,
        PLOT: plot.to_s, PHASE: plot.phase,
        UNIT_TYPE: plot.unit_type
      }.transform_values(&:to_s)
    end

    def self.build_services_fields(service_ids)
      fields = {}

      service_ids.each do |service_id|
        service = Service.find(service_id)
        fields = assign_service_fields(fields, service.category)
      end

      fields.transform_values(&:to_s)
    end

    def self.assign_service_fields(fields, category)
      fields[:FINANCE] = true if category == :finance.to_s
      fields[:LEGAL] = true if category == :legal.to_s
      fields[:UTILITIES] = true if category == :utilities.to_s
      fields[:MANAGER] = true if category == :manager.to_s
      fields[:ESTATE] = true if category == :estate.to_s
      fields[:REMOVALS] = true if category == :removals.to_s

      fields
    end

    def self.md5_hashed_email(email)
      Digest::MD5.hexdigest(email.downcase)
    end
  end
end
